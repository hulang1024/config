return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter").install({
        "c",
        "regex",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "toml",
        "yaml",
        "json",
        "python",
        "javascript",
      })
    end,
  },
}
