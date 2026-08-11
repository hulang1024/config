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
      local dap = require("dap")
      local jdtls = require("jdtls")
      local jdtls_dap = require("jdtls.dap")
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

      local jdtls_base = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "jdtls")
      local lombok_jar = vim.fs.joinpath(jdtls_base, "lombok.jar")

      local function build_jdtls_cmd(configuration, data)
        local launcher = vim.fn.glob(vim.fs.joinpath(jdtls_base, "plugins", "org.eclipse.equinox.launcher_*.jar"), false, true)[1]
        assert(launcher, "jdtls equinox launcher not found; install jdtls via :Mason")

        local uname = vim.uv.os_uname().sysname
        local conf_name = uname == "Linux" and "config_linux" or uname == "Darwin" and "config_mac" or "config_win"
        local shared_config = vim.fs.joinpath(jdtls_base, conf_name)
        local java = (vim.env.JAVA_HOME and vim.fs.joinpath(vim.env.JAVA_HOME, "bin", "java")) or "java"

        -- Invoke java directly so -javaagent is guaranteed on the language server JVM.
        local cmd = {
          java,
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dosgi.checkConfiguration=true",
          "-Dosgi.sharedConfiguration.area=" .. shared_config,
          "-Dosgi.sharedConfiguration.area.readOnly=true",
          "-Dosgi.configuration.cascaded=true",
          "-Xms1G",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          launcher,
          "-configuration",
          configuration,
          "-data",
          data,
        }
        if vim.uv.fs_stat(lombok_jar) then
          table.insert(cmd, 2, "-javaagent:" .. lombok_jar)
        end
        return cmd
      end

      local function map_java_dap(bufnr)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("<leader>dt", function()
          jdtls.test_nearest_method()
        end, "Debug nearest java test (DAP)")
        map("<leader>dT", function()
          jdtls.test_class()
        end, "Debug java test class (DAP)")
        map("<leader>dP", function()
          jdtls.pick_test()
        end, "Pick java test (DAP)")
        map("<leader>dU", "<cmd>JdtUpdateDebugConfig<cr>", "Update java debug configs (DAP)")
        map("<leader>dA", function()
          local client = vim.lsp.get_clients({ name = "jdtls", bufnr = bufnr })[1]
          local cwd = client and client.config.root_dir or vim.fn.getcwd()
          dap.run({
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

        jdtls_dap.setup_dap({ hotcodereplace = "auto" })

        vim.fn.mkdir(jdtls_config_dir, "p")
        vim.fn.mkdir(jdtls_workspace_dir, "p")

        require("jdtls").start_or_attach({
          cmd = build_jdtls_cmd(jdtls_config_dir, jdtls_workspace_dir),
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
              jdt = {
                ls = {
                  lombokSupport = { enabled = true },
                },
              },
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
                -- Discover launchable main classes for F5.
                vim.defer_fn(function()
                  jdtls_dap.setup_dap_main_class_configs()
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
