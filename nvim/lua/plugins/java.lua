return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = { exclude = { "jdtls" } }, -- nvim-jdtls starts it
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "folke/which-key.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = "java",
    config = function()
      local util = require("lspconfig.util")
      local mason_share = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "share")

      local function mason_jars(pattern)
        local seen, jars = {}, {}
        for _, path in ipairs(vim.fn.glob(vim.fs.joinpath(mason_share, pattern), true, true)) do
          local real = vim.uv.fs_realpath(path) or path
          if path ~= "" and not seen[real] then
            seen[real] = true
            table.insert(jars, real)
          end
        end
        return jars
      end

      local function java_bundles()
        local bundles = mason_jars("java-debug-adapter/com.microsoft.java.debug.plugin-*.jar")
        local excluded = {
          ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
          ["jacocoagent.jar"] = true,
        }
        for _, jar in ipairs(mason_jars("java-test/*.jar")) do
          if not excluded[vim.fs.basename(jar)] then
            table.insert(bundles, jar)
          end
        end
        return bundles
      end

      local function jdtls_has_debug(client)
        local cmds = vim.tbl_get(client, "server_capabilities", "executeCommandProvider", "commands") or {}
        return vim.tbl_contains(cmds, "vscode.java.startDebugSession")
      end

      --- Restart stale jdtls clients started without java-debug bundles.
      local function stop_stale_jdtls(bundles)
        if #bundles == 0 then
          return
        end
        for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
          local old = vim.tbl_get(client, "config", "init_options", "bundles") or {}
          if #old == 0 or not jdtls_has_debug(client) then
            vim.notify("Restarting jdtls to load java-debug bundles…", vim.log.levels.INFO)
            client:stop(true)
            vim.wait(10000, function()
              return vim.lsp.get_client_by_id(client.id) == nil
            end, 50)
          end
        end
      end

      local function ensure_java_dap()
        require("jdtls.dap").setup_dap({ hotcodereplace = "auto" })
        local dap = require("dap")
        -- Drop manual presets so F5 only sees discovered Main class launch configs.
        dap.configurations.java = vim.tbl_filter(function(cfg)
          return cfg.name ~= "Launch Current File" and cfg.name ~= "Attach (5005)"
        end, dap.configurations.java or {})
      end

      local function map_java_dap(bufnr)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("<leader>dt", function()
          require("jdtls").test_nearest_method()
        end, "Debug nearest java test (DAP)")
        map("<leader>dT", function()
          require("jdtls").test_class()
        end, "Debug java test class (DAP)")
        map("<leader>dP", function()
          require("jdtls").pick_test()
        end, "Pick java test (DAP)")
        map("<leader>dU", "<cmd>JdtUpdateDebugConfig<cr>", "Update java debug configs (DAP)")
        map("<leader>dA", function()
          local client = vim.lsp.get_clients({ name = "jdtls", bufnr = bufnr })[1]
          local cwd = client and client.config.root_dir or vim.fn.getcwd()
          require("dap").run({
            type = "java",
            request = "attach",
            name = "Attach (5005)",
            hostName = "127.0.0.1",
            port = 5005,
            cwd = cwd,
          })
        end, "Attach java on 5005 (DAP)")
      end

      local find_root = function(fname)
        local root_files = {
          -- Single-module projects
          -- 先搜索
          {
            ".project",
            "build.xml", -- Ant
            "pom.xml", -- Maven
            "settings.gradle", -- Gradle
            "settings.gradle.kts", -- Gradle
          },
          -- Multi-module projects
          -- 后搜索
          { ".git", "build.gradle", "build.gradle.kts" },
        }
        for _, patterns in ipairs(root_files) do
          local root = util.root_pattern(unpack(patterns))(fname)
          if root then
            return root
          end
        end
      end

      local function start_or_attach()
        local bufnr = vim.api.nvim_get_current_buf()
        map_java_dap(bufnr)

        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == "" then
          return
        end
        local root_dir = find_root(path)
        if not root_dir then
          vim.notify("no project root for " .. path, vim.log.levels.WARN)
          return
        end
        local project_name = vim.fs.basename(root_dir)
        local cache_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", project_name)
        local jdtls_config_dir = vim.fs.joinpath(cache_dir, "config")
        local jdtls_workspace_dir = vim.fs.joinpath(cache_dir, "workspace")
        local bundles = java_bundles()
        if #bundles == 0 then
          vim.notify(
            "java-debug-adapter / java-test bundles missing; install via :Mason",
            vim.log.levels.WARN
          )
        end

        stop_stale_jdtls(bundles)
        ensure_java_dap()

        require("jdtls").start_or_attach({
          cmd = {
            "jdtls",
            "-configuration",
            jdtls_config_dir,
            "-data",
            jdtls_workspace_dir,
          },
          root_dir = root_dir,
          settings = {
            java = {
              eclipse = { downloadSources = true },
              configuration = {
                updateBuildConfiguration = "automatic",
              },
              errors = {
                incompleteClasspath = { severity = "error" },
              },
              autobuild = { enabled = true },
            },
          },
          init_options = {
            bundles = bundles,
          },
          handlers = {
            ["language/status"] = function(_, result)
              pcall(function()
                require("fidget").notify(result.message, vim.log.levels.INFO, {
                  group = "jdtls",
                  annote = result.type,
                })
              end)
              if result.type == "ServiceReady" then
                ensure_java_dap()
                -- Discover main classes after project is ready (also disables the short-timeout provider).
                vim.defer_fn(function()
                  require("jdtls.dap").setup_dap_main_class_configs({ verbose = true })
                end, 1500)
              end
            end,
          },
        }, {
          dap = { hotcodereplace = "auto" },
        })
      end

      start_or_attach()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_or_attach,
      })
    end,
  },
}
