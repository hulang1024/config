-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

local keymap = vim.keymap.set
keymap({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })
keymap({ "n", "v" }, "<leader>go", "<Cmd>CodeDiff<CR>", { desc = "CodeDiff" })
