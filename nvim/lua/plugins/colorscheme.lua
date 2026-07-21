-- 激活colorscheme (支持变体: catppuccin-frappe, tokyonight-night, github_dark, …)
vim.g.light_colorscheme = "bamboo"
vim.g.dark_colorscheme = "doom-one"
vim.g.active_colorscheme = ""
vim.g.auto_background = true

local function modname(colorname)
  if colorname:find("^github") then
    return "github"
  elseif colorname:find("^rose%-pine") then
    return colorname
  elseif colorname:find("^doom%-one") then
    return colorname
  end
  return colorname:match("^([^-]+)") or colorname
end

local function set_colorscheme(mode, first)
  vim.opt.background = mode
  vim.g.active_colorscheme = mode == "dark" and vim.g.dark_colorscheme or vim.g.light_colorscheme
  if not first then
    require(modname(vim.g.active_colorscheme))
    vim.cmd.colorscheme(vim.g.active_colorscheme)
  end
end

local function update(first)
  if not vim.g.auto_background then
    return
  end
  local hour = tonumber(os.date("%H"))
  local old_mode = vim.o.background
  local new_mode = 5 < hour and hour < 18 and "light" or "dark"
  if old_mode ~= new_mode or first then
    set_colorscheme(new_mode, first)
  end
end

set_colorscheme(vim.o.background, true)
update(true)

local augroup = vim.api.nvim_create_augroup("colorscheme_update", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  group = augroup,
  callback = update,
})
vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "ToggleBackground",
  callback = function()
    set_colorscheme(vim.o.background == "dark" and "light" or "dark")
  end,
})

local function theme(spec)
  local name = spec.name or (spec[1]:match("([^/]+)$") or ""):gsub("%.nvim$", "")
  local main = spec.main or name
  --- 仅加载活动主题（优先级1000），以避免启动时的闪现。
  --- 其他主题保持懒加载，可按需加载。
  spec.lazy = name ~= modname(vim.g.active_colorscheme)
  spec.priority = 1000
  local user_config = spec.config
  spec.config = function(plugin, opts)
    if user_config then
      user_config(plugin, opts)
    elseif opts then
      local setup = require(main).setup
      if setup then
        setup(opts)
      end
    end
    if name == modname(vim.g.active_colorscheme) then
      vim.cmd.colorscheme(vim.g.active_colorscheme)
    end
  end
  return spec
end

return {
  theme({
    "navarasu/onedark.nvim",
    opts = {
      style = "warmer",
      transparent = false,
    },
  }),
  theme({
    "ellisonleao/gruvbox.nvim",
  }),
  theme({
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  }),
  theme({
    "projekt0n/github-nvim-theme",
    name = "github",
    main = "github-theme",
  }),
  theme({
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent = true,
      float = {
        transparent = true,
      },
      dim_inactive = {
        enabled = false,
      },
    },
  }),
  theme({
    "rebelot/kanagawa.nvim",
    opts = {
      theme = "wave",
      transparent = false,
    },
  }),
  theme({
    "nyoom-engineering/oxocarbon.nvim",
  }),
  theme({
    "scottmckendry/cyberdream.nvim",
  }),
  theme({
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      styles = {
        italic = false,
      },
    },
  }),
  theme({
    "uloco/bluloco.nvim",
    dependencies = { "rktjmp/lush.nvim" },
  }),
  theme({
    "vague-theme/vague.nvim",
  }),
  theme({
    "webhooked/kanso.nvim",
  }),
  theme({
    "kamwitsta/vinyl.nvim",
    opts = {
      variant = "darker",
    },
  }),
  theme({
    "ribru17/bamboo.nvim",
  }),
  theme({
    "NTBBloodbath/doom-one.nvim",
    config = function()
      -- Add color to cursor
      vim.g.doom_one_cursor_coloring = true
      -- Set :terminal colors
      vim.g.doom_one_terminal_colors = true
      -- Enable italic comments
      vim.g.doom_one_italic_comments = true
      -- Enable TS support
      vim.g.doom_one_enable_treesitter = true
      -- Color whole diagnostic text or only underline
      vim.g.doom_one_diagnostics_text_color = true
      -- Enable transparent background
      vim.g.doom_one_transparent_background = false

      -- Pumblend transparency
      vim.g.doom_one_pumblend_enable = true
      vim.g.doom_one_pumblend_transparency = vim.o.pumblend

      -- Plugins integration
      vim.g.doom_one_plugin_neorg = true
      vim.g.doom_one_plugin_barbar = true
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_neogit = true
      vim.g.doom_one_plugin_nvim_tree = true
      vim.g.doom_one_plugin_dashboard = true
      vim.g.doom_one_plugin_startify = true
      vim.g.doom_one_plugin_whichkey = true
      vim.g.doom_one_plugin_indent_blankline = true
      vim.g.doom_one_plugin_vim_illuminate = true
      vim.g.doom_one_plugin_lspsaga = true
    end,
  }),
  theme({
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
  }),
}
