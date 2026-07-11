return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_auto_execute_table_helpers = true
      vim.g.db_ui_save_location = "~/dadbod_ui"
      vim.g.db_ui_tmp_query_location = "~/dadbod_ui/tmp"
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_disable_mappings_sql = true

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "mysql", "sql", "plsql" },
        callback = function(event)
          local bufnr = event.buf
          local is_dbui_buffer = vim.b[bufnr].dbui_db_name ~= nil or vim.b[bufnr].db ~= nil
          if not is_dbui_buffer then
            return
          end
          local map = function(mode, key, rhs, desc)
            vim.keymap.set(mode, "<localleader>" .. key, rhs, { desc = desc, buffer = event.buf })
          end
          map({ "n", "v" }, "r", "<Plug>(DBUI_ExecuteQuery)", "Execute Query")
          map("n", "s", "<Plug>(DBUI_SaveQuery)", "Save Query")
          map("n", "e", "<Plug>(DBUI_EditBindParameters)", "Edit Bind Parameters")
        end,
      })

      vim.api.nvim_create_user_command("DBUITab", function()
        vim.cmd("tabnew | execute 'DBUI'")
        vim.cmd("bwipeout #")
        vim.cmd("normal jjojo")
        vim.cmd("wincmd p | vertical resize 39 | wincmd p")
      end, { desc = "打开DBUI Tab" })
    end,
  },
}
