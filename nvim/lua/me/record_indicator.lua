local rec_win_id = nil
local rec_buf_id = nil

local function show_rec_indicator()
  if rec_win_id and vim.api.nvim_win_is_valid(rec_win_id) then return end

  rec_buf_id = vim.api.nvim_create_buf(false, true)
  local reg = vim.fn.reg_recording()
  local text = string.format("  REC @%s  ", reg)
  vim.api.nvim_buf_set_lines(rec_buf_id, 0, -1, false, { text })

  local width = vim.api.nvim_strwidth(text)
  local height = 1
  local col = (vim.o.columns - width) / 2
  local row = 1

  rec_win_id = vim.api.nvim_open_win(rec_buf_id, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = 150,
  })

  vim.api.nvim_set_option_value("winblend", 60, { win = rec_win_id })
  vim.api.nvim_set_option_value("winhighlight", "Normal:DiagnosticError", { win = rec_win_id })
end

local function hide_rec_indicator()
  if rec_win_id and vim.api.nvim_win_is_valid(rec_win_id) then
    vim.api.nvim_win_close(rec_win_id, true)
    rec_win_id = nil
  end
  if rec_buf_id and vim.api.nvim_buf_is_valid(rec_buf_id) then
    vim.api.nvim_buf_delete(rec_buf_id, { force = true })
    rec_buf_id = nil
  end
end

local M = {}

function M.setup()
  local macro_group = vim.api.nvim_create_augroup("MacroRecording", { clear = true })

  vim.api.nvim_create_autocmd("RecordingEnter", {
    group = macro_group,
    callback = show_rec_indicator,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = macro_group,
    callback = hide_rec_indicator,
  })
end

return M
