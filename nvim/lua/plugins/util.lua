return {
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
