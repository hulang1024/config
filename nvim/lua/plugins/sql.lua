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

      vim.api.nvim_create_user_command("DBUITab", function()
        vim.cmd("tabnew | execute 'DBUIFindBuffer'")
      end, { desc = "打开DBUI Tab" })
    end,
  },
}
