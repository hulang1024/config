require("me.python").setup()
require("me.hadev").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UnityProjectCSharp", { clear = true }),
  callback = function()
    vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

    local ida_export = require("me.ida_export")
    local syncasm = require("me.syncasm")
    local key_prefix = "<localleader>e"
    local map = function(key, func, opts)
      opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts)
      vim.keymap.set("n", key_prefix .. key, func, opts)
    end
    --stylua: ignore start
    map("r", function() ida_export.run_command(false) end, { desc = "导出当前文件" })
    map("R", function() ida_export.run_command(true) end, { desc = "导出当前文件(重新)" })
    map("o", ida_export.open_export_cs, { desc = "打开导出结果文件" })
    map("f", ida_export.find_unfixed_files, { desc = "查找未修正的文件" })
    map("j", syncasm.sync_cs_to_asm, { desc = "定位到方法的汇编代码" })

    local wk = require("which-key")
    wk.add({
      { key_prefix, group = "逆向工具" }
    })
    --stylua: ignore end
  end,
})
