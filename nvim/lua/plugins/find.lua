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
          file_ignore_patterns = {
            "^%.git[/\\]",
          },
          path_display = { "filename_first" },
          mappings = {
            i = {
              ["<C-s>"] = "select_horizontal",
            },
            n = {
              ["q"] = "close",
              ["<C-s>"] = "select_horizontal",
            },
          },
          border = false,
          winblend = function()
            return vim.o.winblend
          end,
        },
        pickers = {
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = {
              n = {
                ["d"] = "delete_buffer",
              },
            },
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
  {
    "folke/flash.nvim",
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>hh", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>ht", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r",          mode = { "o" },           function() require("flash").remote() end, desc = "Remote Flash" },
      { "R",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
    },
  },
}
