return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "CodeDiff" },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
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
