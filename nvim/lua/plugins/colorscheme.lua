return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "warmer",
      transparent = false,
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {},
    -- config = function(opts)
    -- require("gruvbox").setup(opts)
    -- vim.cmd("colorscheme gruvbox")
    -- end,
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
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
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
    },
  },
}
