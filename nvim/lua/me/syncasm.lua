local M = {}

local function get_csharp_method_name()
  local parser = vim.treesitter.get_parser(0)
  if not parser then
    vim.notify("获取treesitter parser失败", vim.log.levels.ERROR)
    return nil
  end
  parser:parse(true)
  local node = vim.treesitter.get_node()
  while node do
    local type = node:type()
    if type == "constructor_declaration" or type == "method_declaration" or type == "property_declaration" then
      local name_node = node:field("name")[1]
      if name_node then
        return vim.treesitter.get_node_text(name_node, 0)
      end
    end
    node = node:parent()
  end
end

local function get_asm_win(base_filename)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local target_path = vim.fs.joinpath("output", base_filename)
    if string.find(buf_name, target_path, 1, true) then
      return win
    end
  end
  return nil
end

function M.sync_cs_to_asm()
  local method_name = get_csharp_method_name()
  if not method_name or method_name == "" then
    return
  end

  local base_filename = vim.fn.expand("%:t")
  local asm_win = get_asm_win(base_filename)
  if not asm_win then
    require("me.ida_export").open_export_cs()
    asm_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd p")
  end

  vim.api.nvim_win_call(asm_win, function()
    vim.opt_local.scrolloff = 0
    local pattern = string.format("\\v//Fun Name:.*(get_|set_)?%s", method_name)
    local found = vim.fn.search(pattern, "w")
    if found > 0 then
      local comment_line = vim.fn.line(".")
      local target_line = comment_line - 1
      vim.api.nvim_win_set_cursor(0, { target_line, 0 })
      vim.cmd("normal! zt")
    end
  end)
end

return M
