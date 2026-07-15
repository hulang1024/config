-- 激活colorscheme (支持变体: catppuccin-frappe, tokyonight-night, github_dark, …)
vim.g.colorscheme = "catppuccin-frappe"

local function modname(colorname)
  if colorname:find("^github") then
    return "github"
  end
  return colorname:match("^([^-]+)") or colorname
end

--- 仅加载活动主题（优先级1000），以避免启动时的闪现。
--- 其他主题保持懒加载，可按需加载。
local function color(spec)
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
      require(main).setup(opts)
    end
    if is_active then
      vim.cmd.colorscheme(vim.g.colorscheme)
    end
  end
  return spec
end

return {
  color({
    "navarasu/onedark.nvim",
    opts = {
      style = "warmer",
      transparent = false,
    },
  }),
  color({
    "ellisonleao/gruvbox.nvim",
    opts = {},
  }),
  color({
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  }),
  color({
    "projekt0n/github-nvim-theme",
    name = "github",
    main = "github-theme",
  }),
  color({
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
  color({
    "rebelot/kanagawa.nvim",
    opts = {
      theme = "wave",
      transparent = false,
    },
  }),
}
