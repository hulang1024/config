return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      max_count = 10,
      restricted_keys = {
        ["j"] = false,
        ["k"] = false,
      },
      disabled_keys = {
        ["<Up>"] = { "c", "i" },
        ["<Down>"] = { "c", "i" },
        ["<Left>"] = { "c", "i" },
        ["<Right>"] = { "c", "i" },
      },
    },
  },
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
    event = "VeryLazy",
    config = function ()
      require("mini.misc").setup_restore_cursor({ center = true })
    end
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
