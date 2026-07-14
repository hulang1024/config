return {
  {
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        json = { "biome" },
        javascript = { "biome" },
        typescript = { "biome" },
        cs = { "csharpier" },
        sql = { "sqruff" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local allowed = { "lua", "json", "sql" }
        if vim.tbl_contains(allowed, ft) then
          return {
            timeout_ms = 1000,
            lsp_format = "never",
          }
        else
          return nil
        end
      end,
    },
    lazy = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
  },
}
