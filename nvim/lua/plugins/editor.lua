return {
  {
    "nvim-mini/mini.files",
    version = false,
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter").install({
        "c",
        "regex",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "toml",
        "yaml",
        "json",
        "python",
        "javascript",
      })
    end,
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
    },
    build = function()
      -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
      -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
      require("blink.cmp").build():pwait()
    end,
    opts = function()
      local sql_sources = { "snippets", "dadbod", "buffer" }
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      return {
        keymap = {
          preset = "super-tab",
          ["<CR>"] = { "accept", "fallback" },
          ["<C-Enter>"] = { "show", "show_documentation", "hide_documentation" },
        },
        completion = {
          documentation = { auto_show = true },
          list = {
            selection = {
              preselect = function()
                return not require("blink.cmp").snippet_active({ direction = 1 })
              end,
            },
          },
        },
        cmdline = {
          completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false } },
          },
        },
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            sql = sql_sources,
            mysql = sql_sources,
            plsql = sql_sources,
            sqlite = sql_sources,
          },
          providers = {
            cmdline = {
              -- ignores cmdline completions when executing shell commands
              enabled = function()
                if vim.fn.getcmdtype() ~= ":" then
                  return true
                end
                local cmd = vim.fn.getcmdline()
                if cmd:match("^[%%0-9,'<>%-]*!") then
                  return false
                end
                local ignore_cmds = { "checkhealth" }
                for _, word in ipairs(ignore_cmds) do
                  if cmd:match("^" .. word .. "%s") then
                    return false
                  end
                end
                return true
              end,
            },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        fuzzy = { implementation = "rust" },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
  },
}
