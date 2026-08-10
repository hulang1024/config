vim.api.nvim_create_user_command("ApiWork", function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http" },
    callback = function()
      vim.cmd("Rest env set .env.prod")
    end,
  })

  vim.cmd("tabnew API")
  vim.cmd("tcd E:/work/qqhl/api")
  vim.cmd("e login.http")
  vim.cmd("sp order.http")
  vim.cmd("wincmd p | resize 7")
  vim.defer_fn(function ()
    vim.cmd("Rest run")
    vim.cmd("wincmd l | wincmd L | wincmd h | wincmd j | norm 4G")
  end, 50)
end, {})
