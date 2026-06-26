return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = not vim.g.vscode },
      picker = { enabled = not vim.g.vscode },
      notifier = { enabled = not vim.g.vscode },
      quickfile = { enabled = not vim.g.vscode },
    },
  },
}
