return {
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
      },
    },
    -- event = { "BufReadPost", "BufNewFile" },
    lazy = true,
    config = function()
      require("dropbar").setup({
        bar = {
          sources = function(buf, _)
            local sources = require("dropbar.sources")
            local utils = require("dropbar.utils")
            if vim.bo[buf].ft == "markdown" then
              return {
                -- sources.path,
                sources.markdown,
              }
            end
            if vim.bo[buf].buftype == "terminal" then
              return {
                sources.terminal,
              }
            end
            return {
              -- sources.path,
              utils.source.fallback({
                sources.lsp,
                sources.treesitter,
              }),
            }
          end,
        },
        icons = { kinds = { dir_icon = "" } },
      })
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "",
        },
        scope = {
          enabled = true,
          char = "|",
          highlight = "Function",
          show_start = false,
          show_end = false,
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
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
      -- local lsp_symbols = require("trouble").statusline({
      --   mode = "lsp_document_symbols",
      --   groups = {},
      --   title = false,
      --   filter = { range = true },
      --   format = "{kind_icon}{symbol.name:Normal}",
      --   hl_group = "lualine_c_normal",
      -- })
      local record_section = {
        function()
          local reg = vim.fn.reg_recording()
          return reg == "" and "" or "recording @" .. reg
        end,
        color = function()
          local theme_color = require("lualine.utils.utils").extract_highlight_colors("DiagnosticError", "fg")
          return { fg = theme_color or "#e86671" }
        end,
      }

      return {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              function()
                local m = vim.fn.mode(1)
                return mode_map[m] or m
              end,
            },
          },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              path = 1,
            },
            -- {
            --   lsp_symbols.get,
            --   cond = lsp_symbols.has,
            -- },
          },
          lualine_x = {
            record_section,
            {
              "progress",
              separator = "",
              padding = { left = 2, right = 1 },
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
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        group = vim.api.nvim_create_augroup("recording_lualine", { clear = true }),
        callback = function()
          require("lualine").refresh()
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.icons",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    opts = {
      lsp = {
        hover = { enabled = true },
        signature = { enabled = true, auto_open = { enabled = false } },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        progress = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      cmdline = {
        enabled = false,
        format = {
          filter = false,
          help = false,
          lua = false,
        },
      },
      messages = {
        enabled = false,
      },
      views = {
        cmdline_popup = {
          border = {
            style = "solid",
          },
        },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "static",
      background = "#282c34",
      window_opts = {
        winblend = 0,
      },
    },
  },
  {
    "sitiom/nvim-numbertoggle",
    enabled = false,
  },
  {
    "folke/which-key.nvim",
    event = "UIEnter",
    config = function()
      -- 开写开头是命令/动作名（叶子），group名则以小写开头
      local wk = require("which-key")
      wk.add(_G.leader_group_keys)
      wk.setup({
        preset = "classic",
        delay = 600,
        win = {
          border = "solid",
        },
        icons = {
          mappings = false,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "m00qek/baleia.nvim",
    lazy = true,
    opts = {},
  },
}
