vim.diagnostic.config({
    virtual_text = false,  -- 在行尾直接显示错误文字
    signs = true,         -- 在代码左侧行号栏显示红绿灯图标
    underline = true,     -- 保持下划线
    update_in_insert = false, -- 在输入模式下不实时更新（避免打字时乱闪）
    severity_sort = true,  -- 当一行有多个错误时，是不是优先显示最严重的（如 Error 优先于 Warn）
})
