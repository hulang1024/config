return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },
  {
    "nvim-mini/mini.surround",
    opts = function(_, opts)
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
}
