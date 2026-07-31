require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'cmd',
    cmd = { height = 0.5 },
    dialog = { height = 0.5, },
    msg = { height = 0.5, timeout = 4000, },
    pager = { height = 0.5, },
  },
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  pcall(vim.fn.serverstart, [[\\.\pipe\NeovimServer]])
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  rocks = {
    hererocks = true,
    server = "https://lumen-oss.github.io/rocks-binaries/",
  },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "netrwPlugin",
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "tohtml",
        -- "matchit",
        -- "matchparen",
        -- "tutor",
      },
    },
  },
})
