return {
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
          documentation = { auto_show = true, window = { winblend = vim.o.winblend } },
          menu = { auto_show = true, winblend = vim.o.winblend },
          ghost_text = { enabled = true },
          list = {
            selection = {
              preselect = function()
                return not require("blink.cmp").snippet_active({ direction = 1 })
              end,
              auto_insert = false,
            },
          },
        },
        cmdline = {
          completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
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
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
}
