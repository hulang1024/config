local M = {}

local ida_buf = nil
local ida_job = nil

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
  local target_file = vim.fs.joinpath(scripts_dir, "output", file_basename)

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

function M.find_unfixed_files()
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
  else
    vim.notify(
      string.format("🎉 太棒了！检查了 %d 个文件，所有文件均已标记为已处理", total_scanned),
      vim.log.levels.INFO,
      { title = "Unfixed Files" }
    )
  end
end

local function process_progress(filename, buf)
  local progress = require("fidget.progress")
  local task = progress.handle.create({
    title = "",
    message = "正在初始化...",
    lsp_client = { name = "逆向文件: " .. filename },
  })
  local timer = vim.uv.new_timer()
  if not timer then
    return
  end
  timer:start(
    0,
    800,
    vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(buf) or ida_job == nil then
        timer:stop()
        timer:close()
        if task.percentage ~= 100 then
          task:cancel()
        end
        return
      end
      local line_cnt = vim.api.nvim_buf_line_count(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, math.max(0, line_cnt - 100), line_cnt, false)
      local last_line = ""
      local percent = 10
      for i = #lines, 1, -1 do
        local line = lines[i]
        if line and line:match("%S") then
          last_line = line
          if line:find("No types/methods", 1, true) or line:find("post%-IDA 工作流完成", 1, true) then
            percent = 100
          end
          break
        end
      end
      if last_line ~= "" then
        task.message = last_line
        -- task.percentage = percent
      end

      if percent >= 100 then
        timer:stop()
        timer:close()
        task.message = "完成！"
        task:finish()
      end
    end)
  )
end

function M.run_command(ignore_exists)
  if ida_job then
    vim.notify("导出任务正在进行", vim.log.levels.ERROR)
    return
  end
  if ida_buf and vim.api.nvim_buf_is_valid(ida_buf) then
    vim.api.nvim_buf_delete(ida_buf, { force = true })
  end

  require("noice").cmd("dismiss")

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
    local target_file = vim.fs.joinpath(scripts_dir, "output", file_basename)
    if vim.fn.filereadable(target_file) == 1 then
      local mtime = vim.fn.getftime(target_file)
      local formatted_time = os.date("%Y-%m-%d %H:%M:%S", mtime)
      vim.notify(
        "目标文件已存在。\n文件位置：" .. target_file .. "\n生成时间：" .. formatted_time,
        vim.log.levels.WARN
      )
      return
    end
  end

  local cmd = {
    "python",
    vim.fs.joinpath(scripts_dir, "prepare_ida_export.py"),
    "--export-f5",
    vim.fs.joinpath(scripts_dir, "export_f5.py"),
    "--ida-log",
    vim.fs.joinpath(scripts_dir, "log/ida_log.txt"),
    "--idb",
    vim.fs.joinpath(scripts_dir, "gamedata/libil2cpp.so.i64"),
    "--cs",
    current_file,
    "--fix-out-dir",
    vim.fs.joinpath(scripts_dir, "output"),
    "-O",
    vim.fs.joinpath(scripts_dir, "output", file_basename),
    "--replay-full",
    "",
  }
  ida_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(ida_buf, function()
    vim.opt_local.scrollback = 100000
    vim.opt_local.scrolloff = 0
    ida_job = vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function(_, exit_code, _)
        if exit_code == 0 then
          vim.notify("导出成功！", vim.log.levels.INFO)
        else
          if exit_code == 1 or exit_code == 137 or exit_code == 143 or exit_code == 129 then
            vim.notify("导出已被中断", vim.log.levels.WARN)
          else
            vim.notify("导出异常退出 (代码: " .. exit_code .. ")", vim.log.levels.ERROR)
          end
        end
        ida_job = nil
      end,
    })
  end)
  process_progress(file_basename, ida_buf)
end

function M.interrupt(silent)
  if ida_job then
    vim.fn.jobstop(ida_job)
  elseif not silent then
    vim.notify("当前没有正在运行的导出任务", vim.log.levels.WARN)
  end
end

function M.toggle_window()
  if not (ida_buf and vim.api.nvim_buf_is_valid(ida_buf)) then
    vim.notify("当前没有正在运行的导出任务", vim.log.levels.WARN)
    return
  end
  local win_id = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_buf(win_id) == ida_buf then
    vim.api.nvim_win_close(win_id, true)
    return
  end
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " IDA Export ",
    title_pos = "center",
    zindex = 50,
  }
  win_id = vim.api.nvim_open_win(ida_buf, true, win_opts)
  vim.cmd("startinsert")
  local function close_win()
    if vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_win_close(win_id, true)
    end
  end
  vim.keymap.set({ "n", "t" }, "q", close_win, { buffer = ida_buf, nowait = true })
  vim.keymap.set({ "n", "t" }, "<c-c>", function()
    close_win()
    M.interrupt(true)
  end, { buffer = ida_buf, nowait = true })
end

return M
