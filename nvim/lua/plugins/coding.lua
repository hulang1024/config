return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        json = { "biome" },
      },
      format_on_save = {
        lsp_format = "never",
      },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            lsp_fallback = true,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          o = ai.gen_spec.treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
          -- Whole buffer
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      })
    end,
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = function()
      require("mini.surround").setup({
        mappings = {
          add = "ys", -- Add surrounding in Normal and Visual modes
          delete = "ds", -- Delete surrounding
          find = "", -- Find surrounding (to the right)
          find_left = "", -- Find surrounding (to the left)
          highlight = "", -- Highlight surrounding
          replace = "cs", -- Replace surrounding

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    --stylua: ignore
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TodoTelescope", "TodoLocList", "TodoQuickFix", "TodoTrouble" },
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "mini.files", words = { "MiniFiles" } },
      },
    },
  },
}
