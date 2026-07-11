return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shell = "powershell",
      float_opts = {
        border = "solid",
        winblend = vim.o.winblend,
      },
    },
    keys = {
      { "<c-/>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Terminal (Current Dir)" },
    },
  },
}
