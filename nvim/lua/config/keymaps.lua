-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

local keymap = vim.keymap.set
keymap({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })
keymap({ "n", "v" }, "<leader>go", "<Cmd>CodeDiff<CR>", { desc = "CodeDiff" })

local ida_export = require('config.ida_export')
keymap('n', '<leader>rr', ida_export.run_command, {
    noremap = true;
    silent = true;
    desc = "IDA Export on Current File";
})
keymap('n', '<leader>rr', ida_export.run_command, {
    noremap = true;
    silent = true;
    desc = "IDA Export on Current File";
})
keymap('n', '<leader>ro', ida_export.open_export_cs, {
    noremap = true;
    silent = true;
    desc = "打开导出CS文件";
})
keymap('n', '<leader>rf', ida_export.find_unfixed_files, {
    noremap = true;
    silent = true;
    desc = "查找未修正的文件";
})

local python = require('config.python')
keymap('n', '<leader>pr', python.run_command, {
    noremap = true;
    silent = true;
    desc = "运行python";
})

local hadev = require("tools.hadev")
keymap('n', '<leader>hl', hadev.toggle_light, { desc = "开关卧室吸顶灯" })
