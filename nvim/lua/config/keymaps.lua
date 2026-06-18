-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

map({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })

map({ "n" }, "<C-p>", LazyVim.pick('files'))

map({ "n", "v" }, "<Leader>a", "\x1bggVG", { desc = "Select All" })

local ida_export = require('config.ida_export')
map('n', '<leader>rr', ida_export.run_command, {
    noremap = true;
    silent = true;
    desc = "IDA Export on Current File";
})
map('n', '<leader>rt', ida_export.toggle_run_command_window, {
    noremap = true;
    silent = true;
    desc = "Toggle IDA Export window";
})
map('n', '<leader>rr', ida_export.run_command, {
    noremap = true;
    silent = true;
    desc = "IDA Export on Current File";
})
map('n', '<leader>ro', ida_export.open_export_cs, {
    noremap = true;
    silent = true;
    desc = "打开导出CS文件";
})
map('n', '<leader>rf', ida_export.find_unfixed_files, {
    noremap = true;
    silent = true;
    desc = "查找未修正的文件";
})

local python = require('config.python')
map('n', '<leader>pr', python.run_command, {
    noremap = true;
    silent = true;
    desc = "执行py";
})
