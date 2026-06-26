return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-Enter>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = { documentation = { auto_show = true } },
      sources = {
        providers = {
          cmdline = {
            -- ignores cmdline completions when executing shell commands
            enabled = function()
              return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "yianwillis/vimcdoc",
  },
}
