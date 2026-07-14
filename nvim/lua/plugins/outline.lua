return {
  {
    "stevearc/aerial.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("aerial").setup({
        backends = {
          ["_"] = { "lsp", "treesitter" },
          vue = { "lsp" },
        },
      })
    end,
  },
}
