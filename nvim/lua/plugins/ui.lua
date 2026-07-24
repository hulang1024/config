return {
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^", "`" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 1000,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      excluded_buftypes = {},
      bookmark_0 = {
        sign = "⚑",
        virt_text = "",
        annotate = false,
      },
    },
  },
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
          globalstatus = true,
          component_separators = "",
          section_separators = { left = " ", right = " " },
        },
        sections = {
          lualine_a = {
            {
              function()
                local m = vim.fn.mode(1)
                return " " .. (mode_map[m] or m)
              end,
              padding = { left = 1, right = 1 },
              separator = { right = "" },
            },
          },
          lualine_b = {
            {
              "filetype",
              icon_only = true,
              icon = { align = "right" },
              separator = { left = "" },
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1,
              separator = { right = "" },
              padding = { left = 0, right = 1 },
            },
          },
          lualine_c = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_x = {
            record_section,
            {
              "encoding",
              cond = function()
                local enc = vim.bo.fileencoding or "utf-8"
                return enc:lower() ~= "utf-8"
              end,
              show_bomb = false,
            },
            "fileformat",
          },
          lualine_y = {},
          lualine_z = {
            {
              "progress",
              padding = { left = 1, right = 0 },
            },
          },
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
