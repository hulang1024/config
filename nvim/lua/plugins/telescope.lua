return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
      },
    },
    lazy = true,
    cmd = "Telescope",
    opts = function()
      return {
        defaults = {
          layout_strategy = "bottom_pane",
          layout_config = {
            height = 0.5,
            prompt_position = "top",
          },
          prompt_title = false,
          results_title = false,
          preview_title = false,
          sorting_strategy = "ascending",
          border = true,
          borderchars = {
            prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            results = { " " },
            preview = { "─", " ", " ", " ", "─", "─", " ", " " },
          },
          winblend = function()
            return vim.o.winblend
          end,
          file_ignore_patterns = {
            "^%.git[/\\]",
          },
          -- path_display = { "filename_first" },
          mappings = {
            i = {
              ["<C-s>"] = "select_horizontal",
            },
            n = {
              ["q"] = "close",
              ["<C-s>"] = "select_horizontal",
            },
          },
        },
        pickers = {
          buffers = {
            previewer = false,
            prompt_title = false,
            show_all_buffers = true,
            sort_mru = true,
            ignore_current_buffer = false,
            mappings = {
              n = {
                ["d"] = "delete_buffer",
              },
            },
          },
          find_files = {
            previewer = false,
            prompt_title = false,
            hidden = true,
          },
          oldfiles = {
            previewer = false,
            prompt_title = false,
          },
          frecency = {
            previewer = false,
            prompt_title = false,
          },
          git_files = {
            previewer = false,
            prompt_title = false,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_ivy({
              layout_config = {
                height = 0.3,
              },
              winblend = function()
                return vim.o.winblend
              end,
              prompt_prefix = "Code action > ",
              prompt_title = false,
            }),
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    opts = {},
    config = function()
      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    version = "*",
    lazy = true,
    config = function()
      require("telescope").load_extension("frecency")
    end,
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "TelescopePathSeparator", { link = "TelescopeResultsComment" })
        end,
      })
    end,
  },
}
