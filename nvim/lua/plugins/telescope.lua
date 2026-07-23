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
          sorting_strategy = "ascending",
          border = false,
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
            hidden = true,
          },
          oldfiles = {
            previewer = false,
          },
          frecency = {
            previewer = false,
          },
          git_files = {
            previewer = false,
          },
        },
      }
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
