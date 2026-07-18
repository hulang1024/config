-- 激活colorscheme (支持变体: catppuccin-frappe, tokyonight-night, github_dark, …)
vim.g.colorscheme = "bamboo"

local function update()
  local hour = tonumber(os.date("%H"))
  local old_bg = vim.o.background
  local new_bg = hour < 18 and "light" or "dark"
  if old_bg ~= new_bg then
    vim.opt.background = new_bg
  end
end

update()

vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  callback = update,
})

local function modname(colorname)
  if colorname:find("^github") then
    return "github"
  elseif colorname:find("^rose-pine") then
    return "rose-pine"
  end
  return colorname:match("^([^-]+)") or colorname
end

--- 仅加载活动主题（优先级1000），以避免启动时的闪现。
--- 其他主题保持懒加载，可按需加载。
local function theme(spec)
  local name = spec.name or (spec[1]:match("([^/]+)$") or ""):gsub("%.nvim$", "")
  local main = spec.main or name
  local is_active = name == modname(vim.g.colorscheme)
  spec.lazy = not is_active
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
    if is_active then
      vim.cmd.colorscheme(vim.g.colorscheme)
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
    "NLKNguyen/papercolor-theme",
  }),
  theme({
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
  }),
}
