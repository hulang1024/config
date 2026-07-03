local mode_map = {
  ['n']      = 'NORMAL',
  ['i']      = 'INSERT',
  ['c']      = 'COMMAND',
  ['t']      = 'TERMINAL',
  ['R']      = 'REPLACE',

  ['v']      = 'VISUAL',
  ['V']      = 'V-LINE',
  ['\22']    = 'V-BLOCK',

  ['s']      = 'SELECT',
  ['S']      = 'SELECT',
  ['\19']    = 'SELECT',

  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22']  = 'O-PENDING',

  ['nt']     = 'T-NORMAL',
  ['cv']     = 'VIM-EX',
}

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
      sections = {
        lualine_a = {
          {
            function()
              local m = vim.fn.mode(1)
              return mode_map[m] or string.sub(m, 1, 1)
            end,
          }
        },
      }
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
            winblend = 40,
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
          hidden = true,
        },
      },
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = "default",
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
