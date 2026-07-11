require("me.python").setup()
require("me.hadev").setup()
require("me.record_indicator").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UnityProjectCSharp", { clear = true }),
  pattern = "cs",
  callback = function()
    vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

    local ida_export = require("me.ida_export")
    local syncasm = require("me.syncasm")
    local key_prefix = "<localleader>r"

    local map = function(key, func, desc)
      local opts = { desc = desc, noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", key_prefix .. key, func, opts)
    end
    --stylua: ignore start
    map("r", function() ida_export.run_command(false) end, "导出当前文件")
    map("R", function() ida_export.run_command(true) end, "导出当前文件(重新)")
    map("w", function() ida_export.toggle_window() end, "打开命令输出窗口")
    map("i", function() ida_export.interrupt() end, "中断导出任务")
    map("o", ida_export.open_export_cs, "打开导出文件")
    map("f", ida_export.find_unfixed_files, "查找未修正的文件")
    map("g", syncasm.sync_cs_to_asm, "定位到方法的汇编代码")

    local wk = require("which-key")
    wk.add({
      { key_prefix, group = "逆向工具" }
    })
  end,
})
