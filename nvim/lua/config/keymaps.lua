-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
map({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })
map({ "n", "v" }, "<leader>go", "<Cmd>CodeDiff<CR>", { desc = "CodeDiff" })
map({ "n", "v" }, "<localleader>s", "<Cmd>source %<CR>", { desc = "Source file" })

local unmap = vim.keymap.del
unmap("n", "H")
unmap("n", "L")
unmap("n", "<C-h>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-l>")
