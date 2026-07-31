vim.bo.commentstring = "-- %s"

vim.api.nvim_create_user_command("ActionQuoteLines", function(opts)
  vim.cmd(("%d,%ds/^[^\\s]*$/'&',/"):format(opts.line1, opts.line2))
end, { desc = "添加引号到每一行", range = "%" })
