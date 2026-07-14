return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    -- 及时渲染注释
    event = { "BufReadPost", "BufNewFile" },
  },
}
