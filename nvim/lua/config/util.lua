local M = {}

vim.g.root_markers = { ".root", ".project", ".nvim.lua", ".git" }

function M.find_root()
  local misc = require("mini.misc")
  return misc.find_root(0, vim.g.root_markers)
end

local function setup_auto_root()
  local misc = require("mini.misc")
  local names = vim.g.root_markers
  vim.o.autochdir = false
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("autoroot", {}),
    nested = true,
    callback = vim.schedule_wrap(function(data)
      if data.buf ~= vim.api.nvim_get_current_buf() then
        return
      end
      local root = misc.find_root(data.buf, names)
      if root == nil then
        return
      end
      vim.fn.chdir(root, "window")
    end),
    desc = "Find root and change current directory",
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    setup_auto_root()
  end,
})

return M
