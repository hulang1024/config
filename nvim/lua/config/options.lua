vim.g.autoformat = false
vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.jumpoptions = "stack"
vim.opt.linespace = 2
vim.opt.list = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff =  999
vim.opt.shell = "powershell.exe"
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.title = false
vim.opt.virtualedit = "block"
vim.opt.visualbell = true
vim.opt.winblend = vim.g.neovide and 60 or 10
vim.opt.wrap = false

if vim.g.vscode then
  vim.g.snacks_dashboard = false
  vim.g.snacks_picker = false
end

if vim.g.neovide then
  vim.g.neovide_floating_blur_amount_x = 1.5
  vim.g.neovide_floating_blur_amount_y = 1.5
end
