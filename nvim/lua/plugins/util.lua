return {
  {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
    dependencies = {
      -- Optional, but highly recommended if you want to use the "Default" timer
      "rcarriga/nvim-notify",
    },
    opts = {
      -- See below for full list of options 👇
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
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
