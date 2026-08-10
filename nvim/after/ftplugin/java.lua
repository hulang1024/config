function find_root()
  local client = vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })[1]
  local root = (client and (client.root_dir or client.config.root_dir))
    or require("mini.misc").find_root(0, { "build.xml" })
  if not root then
    return vim.notify("ant root not found", vim.log.levels.WARN)
  end
  return root
end

vim.api.nvim_buf_create_user_command(0, "Ant", function(opts)
  local root = find_root()
  if not root then return end

  local ant_opts =
    "-Dfile.encoding=UTF-8 -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8"
  if not (vim.env.ANT_OPTS or ""):find("stdout.encoding=UTF-8", 1, true) then
    vim.env.ANT_OPTS = (vim.env.ANT_OPTS and (vim.env.ANT_OPTS .. " ") or "") .. ant_opts
  end

  local cmd = vim.trim("ant " .. table.concat(opts.fargs, " "))
  vim.cmd(('TermExec cmd="%s" dir=%s'):format(cmd, vim.fs.normalize(root)))
end, { nargs = "*", desc = "ant" })

vim.api.nvim_buf_create_user_command(0, "SpringRun", function (opts)
  local root = find_root()
  if not root then return end
  local cmd = "./mvnw spring-boot:run"
  vim.cmd(('TermExec cmd="%s" dir=%s'):format(cmd, vim.fs.normalize(root)))
end, { nargs = "*", desc = "spring boot run" })
