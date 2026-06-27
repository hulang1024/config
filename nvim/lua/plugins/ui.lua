return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "" },
    },
  },
  { "akinsho/bufferline.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        format = {
          lua = false,
          filter = false,
          help = false,
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
      delay = 600,
    },
  },
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      terminal = {
        win = {
          position = "float",
          border = "hpad",
          wo = {
            winhighlight = "FloatBorder:NormalFloat",
          },
        },
      },
      dashboard = {
        preset = {
          header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
   ]],
        },
      },
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = "default",
              preview = false,
            },
            auto_close = true,
            jump = { close = true },
            hidden = false,
            ignored = true,
          },
        },
      },
    },
  },
}
