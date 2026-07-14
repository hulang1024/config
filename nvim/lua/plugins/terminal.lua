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
    cmd = "ToggleTerm",
  },
}
