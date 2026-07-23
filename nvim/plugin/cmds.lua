local function do_copy(content)
  vim.fn.setreg("+", content)
  if content ~= "" then
    vim.notify("Copied: " .. content, vim.log.levels.INFO)
  else
    vim.notify("复制失败", vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
  local path = vim.fs.normalize(vim.fn.expand("%:p"))
  do_copy(path)
end, { desc = "复制绝对路径" })

vim.api.nvim_create_user_command("CopyRootPath", function()
  local path = require("mini.misc").find_root() or ""
  if path then
    do_copy(path)
    return
  else
    vim.notify("未找到根路径", vim.log.levels.WARN)
  end
end, { desc = "复制根路径" })

vim.api.nvim_create_user_command("CopyFilename", function()
  local filename = vim.fn.expand("%:t")
  do_copy(filename)
end, { desc = "复制文件名" })

vim.api.nvim_create_user_command("ToggleDropbar", function()
  if vim.o.winbar == "" then
    require("dropbar")
    vim.opt.winbar = "%{%v:lua.dropbar()%}"
  else
    vim.opt.winbar = ""
  end
end, { desc = "切换Dropbar" })
