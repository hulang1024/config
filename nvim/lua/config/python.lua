local M = {}
function M.run_command()
  local filename = vim.fn.expand("%:p")
  if filename == "" then
    vim.notify("当前没有打开任何文件！", vim.log.levels.WARN)
    return
  end
  if not filename:match("%.py$") then
    vim.notify("文件必须为py", vim.log.levels.ERROR)
    return
  end

  local cmd = { "python", filename, }

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then vim.cmd("bd! " .. buf) end
  end
  vim.bo.bufhidden = "wipe"
  vim.cmd("below 10new")
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart(cmd, {
    term = true,
  })
  vim.keymap.set('n', 'q', '<Cmd>bd!<CR>', { buffer = buf, silent = true })
end

return M
