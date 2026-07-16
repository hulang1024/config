return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "esmuellert/codediff.nvim",
      "m00qek/baleia.nvim",
      "folke/snacks.nvim",
    },
    cmd = "Neogit",
    opts = {
      floating = {
        width = 0.8,
        height = 0.7,
        border = "solid",
      },
    },
  },
}
