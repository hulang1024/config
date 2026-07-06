return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "m00qek/baleia.nvim",
    opts = {},
  },
  {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
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
    config = function()
      local misc = require("mini.misc")
      misc.setup_auto_root()
    end,
  },
}
