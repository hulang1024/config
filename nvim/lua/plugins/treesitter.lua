return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- Upstream: this plugin does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
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
        "xml",
        "python",
        "javascript",
        "typescript",
        "jsdoc",
        "css",
        "html",
        "vue",
        "http",
        "c_sharp",
        "java",
        "javadoc",
        "sql"
      })
    end,
  },
}
