return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    opts = {
      direction = "float",
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.7)
        end,
        border = "solid",
        winblend = vim.o.winblend,
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.opt_local.winbar = ""
        local opts = { buffer = term.bufnr, silent = true }
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Terminal Normal" }))
        vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Terminal Normal" }))
      end,
    },
  },
}
