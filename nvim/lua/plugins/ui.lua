return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "|",
        },
        scope = {
          enabled = true,
          char = "▎",
          highlight = "Function",
          show_start = false,
          show_end = false,
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        themable = true,
        left_mouse_command = false,
        right_mouse_command = false,
        show_buffer_close_icons = false,
        diagnostics = "nvim_lsp",
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
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
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
      })
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
                return mode_map[m] or string.sub(m, 1, 1)
              end,
            },
          },
          lualine_c = {
            "lsp_status",
            "filename",
            {
              symbols.get,
              cond = symbols.has,
            },
          },
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                return reg == "" and "" or "Recording @" .. reg
              end,
              color = function()
                local theme_color = require("lualine.utils.utils").extract_highlight_colors("DiagnosticError", "fg")
                return { fg = theme_color or "#e86671", gui = "italic,bold" }
              end,
            },
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
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
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
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "sitiom/nvim-numbertoggle",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      -- 开写开头是命令/动作名（叶子），group名则以小写开头
      local wk = require("which-key")
      wk.add({
        { "<leader>b", group = "buffers" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>f", group = "file/Find" },
        { "<leader>e", group = "explorer", icon = " " },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>q", group = "quit/session" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
      })
      wk.setup({
        preset = "helix",
        delay = 600,
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    version = "*",
    opts = {},
  },
}
