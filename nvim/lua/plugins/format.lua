return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
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
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            lsp_fallback = true,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
  },
}
