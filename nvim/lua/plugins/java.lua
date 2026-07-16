return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = { exclude = { "jdtls" } }, -- nvim-jdtls starts it
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = "java",
    config = function()
      local util = require("lspconfig.util")
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
        local path = vim.api.nvim_buf_get_name(0)
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
