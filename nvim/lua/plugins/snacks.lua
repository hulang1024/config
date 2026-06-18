if vim.g.vscode then
  return {
    {
      "folke/snacks.nvim",
      opts = {
        -- 显式关闭所有 UI 模块
        dashboard = { enabled = false },
        picker = { enabled = false },
        notifier = { enabled = false },
        quickfile = { enabled = false },
      },
    },
  }
end

return {
  "folke/snacks.nvim",
}
