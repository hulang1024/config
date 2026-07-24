-- 全局
vim.g.autoformat = false

vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

-- 缩进
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true

-- 搜索与替换
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = vim.g.neovide and "nosplit" or "split"

-- 编辑与导航
vim.opt.scrolloff = 2
vim.opt.jumpoptions = "stack"
vim.opt.virtualedit = "block"
vim.opt.mouse = {}
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
function _G.get_fold_text()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local indent = string.match(start_line, "^%s*") or ""
  local content = string.gsub(start_line, "^%s*", "")
  return indent .. " " .. content
end
vim.opt.foldtext = "v:lua.get_fold_text()"
vim.opt.foldenable = true

-- 窗口
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winblend = vim.g.neovide and 10 or 5
vim.opt.pumblend = vim.g.neovide and 10 or 5

-- UI与外观显示
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.opt.report = 10
vim.opt.fillchars = {
  eob = " ",
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
}
vim.opt.wrap = false
vim.opt.list = false
vim.opt.listchars = {
  tab = " ",
  trail = ".",
  nbsp = ".",
}
vim.opt.showcmd = true
vim.opt.showtabline = 1
vim.opt.title = true
vim.opt.titlestring = "%t"
vim.opt.visualbell = true
vim.opt.linespace = 0

-- 其它
if vim.fn.has("win32") == 1 then
  -- 解决LSP的一些问题
  vim.opt.backupcopy = "yes"
end
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
vim.opt.encoding = "utf-8"
if vim.fn.has("win32") == 1 then
  vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "3>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
vim.opt.backup = false
vim.opt.exrc = true

-- diagnostic
vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {},
})

-- neovide 设置
if vim.g.neovide then
  vim.g.neovide_theme = "bg_color"
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_vfx_particle_density = 0.7
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_floating_blur_amount_x = 2
  vim.g.neovide_floating_blur_amount_y = 2
  vim.g.neovide_floating_z_height = 1
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 30
  vim.g.neovide_profiler = false

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1.0
  end)
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.15)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.15)
  end)
end
