return {
  {
    "nvim-mini/mini.files",
    version = false,
    lazy = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- neo-tree will lazily load itself
  },
  {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- 会作为启动时使用（nvim .)
    lazy = false,
    event = "VeryLazy",
    opts = function()
      function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
          local dirname = vim.fn.fnamemodify(dir, ":~")
          local icon, hl = require("mini.icons").get("directory", dirname)
          return string.format(" %%#%s#%s  %%#OilDir#%s %%*", hl, icon, dirname)
        else
          return vim.api.nvim_buf_get_name(0)
        end
      end
      ---@module 'oil'
      ---@type oil.SetupOpts
      return {
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        columns = {
          "icon",
        },
        keymaps = {
          ["q"] = { "actions.close", mode = "n" },
        },
        win_options = {
          winblend = vim.o.winblend,
          winbar = "%!v:lua.get_oil_winbar()",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name)
            if name == ".git" then
              return true
            end
            return false
          end,
        },
        float = {
          padding = 2,
          max_width = 0.4,
          border = "rounded",
          get_win_title = function () return nil end,
          win_options = {
            winblend = vim.o.winblend,
          },
        },
      }
    end,
  },
}
