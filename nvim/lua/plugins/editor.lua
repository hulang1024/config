return {
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
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
          sql = { "snippets", "dadbod", "buffer" },
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
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
  },
  {
    "sitiom/nvim-numbertoggle",
  },
  {
    "yianwillis/vimcdoc",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
