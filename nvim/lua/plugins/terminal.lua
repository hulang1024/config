return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shell = "powershell",
      float_opts = {
        border = "rounded",
        winblend = vim.o.winblend * 0.9,
      },
    },
    keys = {
      { "<c-/>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Terminal (Current Dir)" },
    },
  },
}
