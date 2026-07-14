return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "CodeDiff" },
      { "<leader>gd", "<cmd>CodeDiff file HEAD<cr>", desc = "CodeDiff This File" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "esmuellert/codediff.nvim",
      "m00qek/baleia.nvim",
      "folke/snacks.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
