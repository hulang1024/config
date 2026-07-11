local function find_project_files()
  local root = require("mini.misc").find_root(0, vim.g.root_names or { ".git", ".root" })
  local telescope = require("telescope.builtin")
  telescope.find_files({
    cwd = root,
    hidden = true,
  })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
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
    -- stylua: ignore
    keys = {
      { "<leader> ",  function() require("telescope").extensions.frecency.frecency() end, desc = "Find Files (Frecency)" },
      { "<leader>,",  function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>:",  function() require("telescope.builtin").command_history() end, desc = "Command History" },
      { "<leader>/",  function() require("telescope.builtin").live_grep() end, desc = "Grep Workspace" },
      { "<leader>'",  function() require("telescope.builtin").lsp_document_symbols() end, desc = "LSP Document Symbols" },
      { "<leader>*",  function() require("telescope.builtin").grep_string() end, desc = "Grep Word/Selection", mode = { "n", "x" } },
      { "<leader>.",  function() find_project_files() end, desc = "Find Files (Workspace)" },
      { "<leader>;",  function() require("telescope.builtin").resume() end, desc = "Resume Last Picker" },
      -- files
      { "<leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>fP", function() require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, desc = "Find Plugin File" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
      { "<leader>fp", function() require("telescope").extensions.projects.projects() end, desc = "Projects" },
      { "<leader>fg", function() require("telescope.builtin").git_files() end, desc = "Git Files" },
      -- search
      { '<leader>s"', function() require("telescope.builtin").registers() end, desc = "Registers" },
      { '<leader>s/', function() require("telescope.builtin").search_history() end, desc = "Search History" },
      { "<leader>sa", function() require("telescope.builtin").autocommands() end, desc = "Autocmds" },
      { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Commands" },
      { "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0}) end, desc = "Buffer Diagnostics" },
      { "<leader>sD", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Help Pages" },
      { "<leader>sH", function() require("telescope.builtin").highlights() end, desc = "Highlights" },
      { "<leader>sj", function() require("telescope.builtin").jumplist() end, desc = "Jumps" },
      { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() require("telescope.builtin").loclist() end, desc = "Location List" },
      { "<leader>sm", function() require("telescope.builtin").marks() end, desc = "Marks" },
      { "<leader>sM", function() require("telescope.builtin").man_pages() end, desc = "Man Pages" },
      { "<leader>sq", function() require("telescope.builtin").quickfix() end, desc = "Quickfix List" },
      { "<leader>sg", function() require("telescope.builtin").live_grep({ grep_open_files = true }) end, desc = "Grep Open Buffers" },
      -- lsp
      { "gd",         function() require("telescope.builtin").lsp_definitions() end, desc = "Goto Definition" },
      { "grr",        function() require("telescope.builtin").lsp_references() end, nowait = true, desc = "References" },
      { "gri",        function() require("telescope.builtin").lsp_implementations() end, desc = "Goto Implementation" },
      { "grt",        function() require("telescope.builtin").lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai",        function() require("telescope.builtin").lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao",        function() require("telescope.builtin").lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "<leader>sS", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- git
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git Branches" },
      { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git Commits" },
      -- ui
      { "<leader>uC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Colorschemes" },
    },
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    version = "*",
    lazy = true,
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
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
