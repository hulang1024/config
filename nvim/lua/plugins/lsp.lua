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
          map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
          map("<c-k>", vim.lsp.buf.signature_help, { mode = "i", desc = "Signature Help" })
          map("<leader>cR", Snacks.rename.rename_file, { desc = "Rename File" })
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
    opts = {
      ensure_installed = { "lua_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
  },
}
