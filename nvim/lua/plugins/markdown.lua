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
    },
  },
}
