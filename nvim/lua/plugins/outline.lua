return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
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
