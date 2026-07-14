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
    config = function()
      local misc = require("mini.misc")
      misc.setup_auto_root(vim.g.root_names or { ".root", ".git" })
    end,
  },
}
