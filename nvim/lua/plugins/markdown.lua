return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
      overrides = {
        filetype = {
          Avante = {
            anti_conceal = {
              enabled = false,
            },
          },
        },
      },
      anti_conceal = {
        enabled = false,
      },
      heading = {
        width = "block",
        backgrounds = { "", "", "", "", "", "" },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
