local M = {}
local ida_term = nil

function M.toggle_run_command_window()
  if ida_term and ida_term.buf and vim.api.nvim_buf_is_valid(ida_term.buf) then
    ida_term:toggle()
  end
end

function M.run_command()
  -- 获取环境变量
  local scripts_dir = vim.env.IDA_TOOL_SCRIPTS_DIR

  -- 检查环境变量是否存在
  if not scripts_dir or scripts_dir == "" then
    vim.notify("未找到环境变量: IDA_TOOL_SCRIPTS_DIR", vim.log.levels.ERROR)
    return
  end

  local current_file = vim.fn.expand("%:p") -- 对应 ${file}
  local file_basename = vim.fn.expand("%:t") -- 对应 ${fileBasename}
  if current_file == "" then
    vim.notify("当前没有打开任何文件！", vim.log.levels.WARN)
    return
  end
  if not file_basename:match("%.cs$") then
    vim.notify("文件必须为C#源", vim.log.levels.ERROR)
    return
  end

  local cmd = {
    "python",
    scripts_dir .. "/prepare_ida_export.py",
    "--export-f5",
    scripts_dir .. "/export_f5.py",
    "--ida-log",
    scripts_dir .. "/log/ida_log.txt",
    "--idb",
    scripts_dir .. "/gamedata/libil2cpp.so.i64",
    "--cs",
    current_file,
    "--fix-out-dir",
    scripts_dir,
    "--replay-full",
    "",
    "-O",
    scripts_dir .. "/output/" .. file_basename,
  }

  if ida_term then
    ida_term:close()
    ida_term = nil
  end
  ida_term = Snacks.terminal.toggle(cmd, {
    win = {
      position = "float",
      border = "solid",
      width = 0.8,
      height = 0.8,
      backdrop = 60,
      wo = {
        winblend = 0,
        number = false,
        relativenumber = false,
        signcolumn = "no",
      }
    }
  })
  vim.keymap.set({ 'n', 't' }, 'q', function ()
    ida_term:toggle()
  end, {
    buffer = ida_term.buf,
    silent = true,
    desc = "Hide Terminal"
  })
  ida_term:on("TermClose", function()
    local exit_code = vim.v.event.status
    if exit_code == 0 then
      vim.notify("IDA 导出成功！", vim.log.levels.INFO)
      M.open_export_cs()
    else
      vim.notify("IDA 导出异常退出 (代码: " .. exit_code .. ")", vim.log.levels.ERROR)
    end
  end, { buf = true })
  vim.keymap.set('n', 'q', function ()
    ida_term:toggle()
  end, { buffer = true })
end


function M.open_export_cs()
  local scripts_dir = vim.env.IDA_TOOL_SCRIPTS_DIR

  if not scripts_dir or scripts_dir == "" then
    vim.notify("未找到环境变量: IDA_TOOL_SCRIPTS_DIR", vim.log.levels.ERROR)
    return
  end

  local file_basename = vim.fn.expand('%:t')
  if file_basename == "" then
    vim.notify("当前没有打开任何文件！", vim.log.levels.WARN)
    return
  end

  -- 拼接目标文件路径
  local target_file = scripts_dir .. "/output/" .. file_basename

  -- 检查文件是否存在 (可选，提升体验)
  if vim.fn.filereadable(target_file) == 0 then
    vim.notify("找不到输出文件: " .. target_file, vim.log.levels.WARN)
    return
  end

  -- 使用 vsplit 打开文件，fnameescape 是为了防止路径中有特殊字符导致报错
  vim.cmd('vsplit ' .. vim.fn.fnameescape(target_file))
  vim.bo.modifiable = false
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = true })
  -- vim.cmd('G')
  -- vim.cmd('?\\v\\/\\/Fun Name')
  -- vim.cmd('normal zz')
end

function M.find_unfixed_files()
  -- 1. 极其严格地让 rg 只输出每个文件的真正第一行（通过匹配行首 `^`）
  -- 格式被死死锁在：`路径:行号:列号:内容`（中间 3 个冒号）
  local cmd = [[rg "^" -g "*.cs" --max-count 1 --no-heading --with-filename --vimgrep .]]
  local lines = vim.fn.systemlist(cmd)
  local qf_list = {}
  local total_scanned = 0 -- 记录扫描的文件总数
  table.sort(lines)
  for _, line in ipairs(lines) do
    -- 2. 解析标准的 3 冒号 vimgrep 格式
    local file, lnum, col, text = line:match("^([^:]+):(%d+):(%d+):(.*)")
    if file and text then
      total_scanned = total_scanned + 1
      -- 去除文本前后的空格，防止因为写了 "  // Fixed"（前面带空格）而漏判
      local trimmed_text = text:gsub("^%s+", ""):gsub("%s+$", "")
      -- 3. 在 Lua 中做真正的反向过滤：只有当首行【不以 指定正则】开头时，才加入列表
      if not trimmed_text:find("^// NOTE: Restored.") then
        table.insert(qf_list, {
          filename = file,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text
        })
      end
    end
  end
  -- 4. 刷新 Quickfix 列表并打开窗口
  vim.fn.setqflist(qf_list, 'r')
  -- 5. 弹出通知与打开窗口
  local unfixed_count = #qf_list
  if unfixed_count > 0 then
    vim.notify(
      string.format("🔍 扫描完毕：共检查了 %d 个文件，发现 %d 个未修复的文件！", total_scanned, unfixed_count),
      vim.log.levels.INFO,
      { title = "Unfixed Files" }
    )
    vim.cmd('copen')
  else
    vim.notify(
      string.format("🎉 太棒了！检查了 %d 个文件，所有文件均已标记为 Fixed！", total_scanned),
      vim.log.levels.INFO,
      { title = "Unfixed Files" }
    )
    vim.cmd('cclose') -- 如果都修复了，顺手帮用户把旧的 quickfix 窗口关掉
  end
end

return M
