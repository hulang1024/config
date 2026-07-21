return {
  {
    "epwalsh/pomo.nvim",
    version = "*",
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
    dependencies = {
      "rcarriga/nvim-notify",
    },
    opts = {},
  },
  {
    "yianwillis/vimcdoc",
  },
  {
    "nvim-mini/mini.misc",
    lazy = true,
  },
  {
    "folke/flash.nvim",
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>Ff", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>Ft", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r",          mode = { "o" },           function() require("flash").remote() end, desc = "Remote Flash" },
      { "R",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
    },
  },
}
