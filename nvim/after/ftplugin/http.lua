local map = function(mode, key, rhs, desc)
  vim.keymap.set(mode, "<localleader>" .. key, rhs, {
    buffer = true,
    desc = desc,
  })
end
map("n", "r", "<Cmd>Rest run<CR>", "Run (Rest)")
map("n", "R", "<Cmd>Rest last<CR>", "Run last (Rest)")
map("n", "l", "<Cmd>sp | Rest logs<CR>", "Edit logs (Rest)")
map("n", "c", "<Cmd>sp | Rest cookies<CR>", "Edit cookies (Rest)")
map("n", "e", function ()
  require("telescope").load_extension("rest")
  require("telescope").extensions.rest.select_env()
end, "Select env (Rest)")
