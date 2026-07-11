return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {},
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = {
          set_jumps = true,
        },
      })
      local moves = {
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
          ["]a"] = "@parameter.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[a"] = "@parameter.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]A"] = "@parameter.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[A"] = "@parameter.outer",
        },
      }
      for method, map in pairs(moves) do
        for key, node in pairs(map) do
          local node_name = node:match("@(.-)%.") or node
          local desc = string.format(
            "%s %s %s",
            method:match("next") and "Next" or "Previous",
            node_name,
            method:match("start") and "start" or "end"
          )
          vim.keymap.set({ "n", "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.move")[method](node, "textobjects")
          end, { desc = desc })
        end
      end
    end,
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    config = function()
      local gen_spec = require("mini.ai").gen_spec
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          f = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          a = gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          o = gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
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
          add = "sa", -- Add surrounding in Normal and Visual modes
          delete = "sd", -- Delete surrounding
          find = "sf", -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr", -- Replace surrounding

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
  },
}
