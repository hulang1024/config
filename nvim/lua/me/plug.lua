local M = {}

function M.use(plugin_name)
  local ok, mod = pcall(require, "me." .. plugin_name)
  if ok and mod.setup then
    mod.setup()
  end
end

return M
