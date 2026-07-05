local mode_map = {
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["c"] = "COMMAND",
  ["t"] = "TERMINAL",
  ["R"] = "REPLACE",

  ["v"] = "VISUAL",
  ["V"] = "V-LINE",
  ["\22"] = "V-BLOCK",

  ["s"] = "SELECT",
  ["S"] = "SELECT",
  ["\19"] = "SELECT",

  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",

  ["nt"] = "T-NORMAL",
  ["cv"] = "VIM-EX",
}

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
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
          },
        },
        lualine_c = {
          "filename",
          {
            function()
              local reg = vim.fn.reg_recording()
              return reg == "" and "" or "Recording @" .. reg
            end,
            color = function()
              local theme_color = require("lualine.utils.utils").extract_highlight_colors("DiagnosticError", "fg")
              return { fg = theme_color or "#e86671", gui = "italic" }
            end,
          },
        },
        lualine_x = {
          {
            "progress",
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "location",
            padding = { left = 0, right = 2 },
          },
          "encoding",
          {
            function()
              local symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              }
              return symbols[vim.bo.fileformat] or vim.bo.fileformat
            end,
          },
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
    },
    init = function()
      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        callback = function()
          require("lualine").refresh()
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.icons",
    version = "*",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        hover = { enabled = true },
        signature = { enabled = true },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      views = {
        cmdline_popup = {
          border = {
            style = "solid",
          },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {},
  },
}
