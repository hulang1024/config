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
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
        { path = "mini.files", words = { "MiniFiles" } },
      },
    },
  },
}
