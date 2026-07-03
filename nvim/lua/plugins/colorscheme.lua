return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "warmer",
      transparent = false,
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    opts = {
      transparent = true,
      float = {
        transparent = true,
      },
      dim_inactive = {
        enabled = false,
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave",
      transparent = false,
    }
  },
}
