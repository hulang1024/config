return {
  {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConf", {}),
        callback = function(ev)
          local map = function(keys, func, opts)
            vim.keymap.set(opts.mode or "n", keys, func, { buffer = ev.buf, desc = opts.desc })
          end
          -- stylua: ignore start
          map("gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
          map("<c-k>", function() return vim.lsp.buf.signature_help() end, { mode = "i", desc = "Signature Help" })
          map("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
          map("<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
          map("<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
          map("<leader>cr", vim.lsp.buf.rename, { desc ="Rename" })
          map("]]", function() Snacks.words.jump(vim.v.count1) end, { has = "documentHighlight", desc = "Next Reference" })
          map("[[", function() Snacks.words.jump(-vim.v.count1) end, { has = "documentHighlight", desc = "Prev Reference" })
          map("<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, { has = "documentHighlight", desc = "Next Reference" })
          map("<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, { has = "documentHighlight", desc = "Prev Reference" })
          -- stylua: ignore end
        end,
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {},
    cmd = "Mason",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
  },
}
