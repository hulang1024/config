local M = {}

---@type snacks.win
local ida_term = nil

function M.open_export_cs(cs_path)
  local scripts_dir = vim.env.IDA_TOOL_SCRIPTS_DIR

  if not scripts_dir or scripts_dir == "" then
    vim.notify("未找到环境变量: IDA_TOOL_SCRIPTS_DIR", vim.log.levels.ERROR)
    return
  end

  local file_basename = cs_path or vim.fn.expand("%:t")
  if file_basename == "" then
    vim.notify("当前没有打开任何文件！", vim.log.levels.WARN)
    return
  end

  -- 拼接目标文件路径
  local target_file = vim.fs.joinpath(scripts_dir, "/output/", file_basename)

  -- 检查文件是否存在 (可选，提升体验)
  if vim.fn.filereadable(target_file) == 0 then
    vim.notify("找不到输出文件: " .. target_file, vim.log.levels.WARN)
    return
  end

  -- 使用 vsplit 打开文件，fnameescape 是为了防止路径中有特殊字符导致报错
  vim.cmd("vsplit " .. vim.fn.fnameescape(target_file))
  vim.bo.modifiable = false
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.opt.wrap = true
  vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true })
  -- vim.cmd('G')
  -- vim.cmd('?\\v\\/\\/Fun Name')
  -- vim.cmd('normal zz')
end

local function find_unfixed_files()
  -- 1. 极其严格地让 rg 只输出每个文件的真正第一行（通过匹配行首 `^`）
  -- 格式被死死锁在：`路径:行号:列号:内容`（中间 3 个冒号）
  local cmd = { "rg", "^", "-g", "*.cs", "--max-count", "1", "--no-heading", "--with-filename", "--vimgrep", "." }
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
      if not trimmed_text:find("^// NOTE: Restored%.") then
        table.insert(qf_list, {
          filename = file,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text,
        })
      end
    end
  end
  -- 4. 刷新 Quickfix 列表并打开窗口
  vim.fn.setqflist(qf_list, "r")
  -- 5. 弹出通知与打开窗口
  local unfixed_count = #qf_list
  if unfixed_count > 0 then
    vim.notify(
      string.format(
        "🔍 扫描完毕：共检查了 %d 个文件，发现 %d 个未修复的文件！",
        total_scanned,
        unfixed_count
      ),
      vim.log.levels.INFO,
      { title = "Unfixed Files" }
    )
    vim.cmd("copen")
  else
    vim.notify(
      string.format("🎉 太棒了！检查了 %d 个文件，所有文件均已标记为已处理", total_scanned),
      vim.log.levels.INFO,
      { title = "Unfixed Files" }
    )
    vim.cmd("cclose") -- 如果都修复了，顺手帮用户把旧的 quickfix 窗口关掉
  end
end

local function run_command(ignore_exists)
  if ida_term and ida_term.buf and vim.api.nvim_buf_is_valid(ida_term.buf) then
    ida_term:toggle()
    return
  end

  local scripts_dir = vim.env.IDA_TOOL_SCRIPTS_DIR

  if not scripts_dir or scripts_dir == "" then
    vim.notify("未找到环境变量: IDA_TOOL_SCRIPTS_DIR", vim.log.levels.ERROR)
    return
  end

  local current_file = vim.fn.expand("%:p")
  local file_basename = vim.fn.expand("%:t")
  if current_file == "" then
    vim.notify("当前没有打开任何文件！", vim.log.levels.WARN)
    return
  end
  if not file_basename:match("%.cs$") then
    vim.notify("文件必须为C#源", vim.log.levels.ERROR)
    return
  end

  if not ignore_exists then
    local target_file = vim.fs.joinpath(scripts_dir, "/output/", file_basename)
    if vim.fn.filereadable(target_file) == 1 then
      local mtime = vim.fn.getftime(target_file)
      local formatted_time = os.date("%Y-%m-%d %H:%M:%S", mtime)
      vim.notify("目标文件已存在。\n文件位置：" .. target_file .. "\n生成时间：" .. formatted_time, vim.log.levels.WARN)
      return
    end
  end

  local cmd = {
    "python",
    vim.fs.joinpath(scripts_dir, "/prepare_ida_export.py"),
    "--export-f5", vim.fs.joinpath(scripts_dir, "/export_f5.py"),
    "--ida-log", vim.fs.joinpath(scripts_dir, "/log/ida_log.txt"),
    "--idb", vim.fs.joinpath(scripts_dir, "/gamedata/libil2cpp.so.i64"),
    "--cs", current_file,
    "--fix-out-dir", vim.fs.joinpath(scripts_dir, "/output/"),
    "-O", vim.fs.joinpath(scripts_dir, "/output/", file_basename),
    "--replay-full", "",
  }

  ida_term = Snacks.terminal.toggle(cmd, {
    auto_close = false,
    win = {
      title = "IDA Export",
      position = "float",
      width = 0.8,
      height = 0.8,
      border = "hpad",
    },
  })
  ida_term:on("TermClose", function()
    local exit_code = vim.v.event.status
    if exit_code == 0 then
      vim.notify("IDA 导出成功！", vim.log.levels.INFO)
    else
      vim.notify("IDA 导出异常退出 (代码: " .. exit_code .. ")", vim.log.levels.ERROR)
    end
  end, { buf = true })
  vim.keymap.set({"n", "t"}, "q", function()
    ida_term:toggle()
  end, { buffer = true })
  vim.keymap.set({"n", "t"}, "Q", function()
    ida_term:close()
    M.open_export_cs(file_basename)
  end, { buffer = true })
end

function M.setup()
  vim.fn.setreg("r", "ggO\23// NOTE: Restored.\x1b")

  local map  = vim.keymap.set
  map('n', '<leader>rr', function() run_command(false) end, {
      noremap = true,
      silent = true,
      desc = "导出当前文件",
  })
  map('n', '<leader>rR', function() run_command(true) end, {
      noremap = true,
      silent = true,
      desc = "导出当前文件(重新)",
  })
  map('n', '<leader>ro', M.open_export_cs, {
      noremap = true,
      silent = true,
      desc = "打开导出结果文件",
  })
  map('n', '<leader>rf', find_unfixed_files, {
      noremap = true,
      silent = true,
      desc = "查找未修正的文件",
  })
end

return M
