--stylua: ignore start
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc)
  map("n", lhs, rhs, { desc = desc })
end
local map_leader = function(mode, suffix, rhs, desc)
  map(mode, "<leader>" .. suffix, rhs, { desc = desc })
end
local nmap_leader = function(suffix, rhs, desc)
  map_leader("n", suffix, rhs, desc)
end
local xmap_leader = function(suffix, rhs, desc)
  map_leader("x", suffix, rhs, desc)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape" })

map("n", "<localleader>s", "<cmd>source %<cr>", { desc = "Source File" })

_G.leader_group_keys = {
  { "<leader>q", group = "quit" },
  { "<leader>b", group = "buffer", icon = "" },
  { "<leader>t", group = "tab" },
  { "<leader>e", group = "explorer", icon = " " },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>s", group = "session" },
  { "<leader>c", group = "code" },
  { "<leader>u", group = "ui" },
  { "<leader>H", group = "home assistant", icon = "󰟐" },
  { "gr", group = "lsp" },
}

-- quit
nmap_leader("qq", "<cmd>qa<cr>", "Quit All")
nmap_leader("qr", "<cmd>restart<cr><esc>", "Restart")

-- buffer
nmap_leader("<tab>", "<cmd>b #<cr>", "Alternate Buffer")
nmap_leader("bd", "<cmd>bd<cr>", "Delete Buffer")
nmap_leader("bD", "<cmd>bd<cr>", "Delete Buffer and Window")

-- tab
nmap("[t", "<cmd>tabprev<cr>", "Previous Tab")
nmap("]t", "<cmd>tabnext<cr>", "Next Tab")
nmap_leader("tc", "<cmd>tabclose<cr>", "Close Tab")
nmap_leader("to", "<cmd>tabonly<cr>", "Close Other Tabs")
nmap_leader("tl", "<cmd>tabs<cr>", "List Tabs")
nmap_leader("tn", "<cmd>tabnew<cr>", "New Tab")

-- explorer
nmap("-", "<cmd>Oil --float<cr>", "Open parent directory (float window)")
nmap_leader("-", "<cmd>Oil<cr>", "Open parent directory")
nmap_leader("ed", function() require("mini.files").open() end, "File Explorer (cwd)")
nmap_leader("ef", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, "File Explorer")
nmap_leader("ex", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           "Buffer Diagnostics (Trouble)")
nmap_leader("eX", "<cmd>Trouble diagnostics toggle<cr>",                        "Diagnostics (Trouble)")
nmap_leader("es", "<cmd>Trouble symbols toggle focus=false<cr>",                "Symbols (Trouble)")
nmap_leader("el", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references / ... (Trouble)")
nmap_leader("eq", "<cmd>Trouble qflist toggle<cr>",                             "Quickfix List (Trouble)")
nmap_leader("eQ", "<cmd>Trouble loclist toggle<cr>",                            "Location List (Trouble)")
nmap_leader("et", "<cmd>Trouble todo toggle<cr>",                               "Todo (Trouble)")
nmap_leader("eT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", "Todo/Fix/Fixme (Trouble)")

-- fuzzy find
local function find_project_files()
  local root = require("mini.misc").find_root(0, vim.g.root_names or { ".git", ".root" })
  local telescope = require("telescope.builtin")
  telescope.find_files({
    cwd = root,
    hidden = true,
  })
end

nmap_leader(",",  function() require("telescope.builtin").buffers() end, "Buffers")
nmap_leader(".",  find_project_files, "Project Files")
nmap_leader("r",  function() require("telescope").extensions.frecency.frecency() end, "Frecency Files")
nmap_leader(":",  function() require("telescope.builtin").command_history() end, "Command History")
nmap_leader("/",  function() require("telescope.builtin").live_grep() end, "Grep Workspace")
nmap_leader("'",  function() require("telescope.builtin").lsp_document_symbols() end, "LSP Document Symbols")
nmap_leader("*",  function() require("telescope.builtin").grep_string() end, "Grep Word/Selection")
xmap_leader("*",  function() require("telescope.builtin").grep_string() end, "Grep Word/Selection")
nmap_leader(";",  function() require("telescope.builtin").resume() end, "Resume Last Picker")
nmap_leader("fC", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, "Config File")
nmap_leader("fP", function() require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, "Plugin File")
nmap_leader("fr", function() require("telescope.builtin").oldfiles() end, "Recent Files")
nmap_leader("fp", function() require("telescope").extensions.projects.projects() end, "Projects")
nmap_leader("fg", function() require("telescope.builtin").live_grep({ grep_open_files = true }) end, "Grep Open Buffers")
nmap_leader("fG", function() require("telescope.builtin").git_files() end, "Git Files")
nmap_leader("f'", function() require("telescope.builtin").registers() end, "Registers")
nmap_leader("f/", function() require("telescope.builtin").search_history() end, "Search History")
nmap_leader("fa", function() require("telescope.builtin").autocommands() end, "Autocmds")
nmap_leader("fc", function() require("telescope.builtin").commands() end, "Commands")
nmap_leader("fd", function() require("telescope.builtin").diagnostics({ bufnr = 0}) end, "Buffer Diagnostics")
nmap_leader("fD", function() require("telescope.builtin").diagnostics() end, "Diagnostics")
nmap_leader("fh", function() require("telescope.builtin").help_tags() end, "Help Pages")
nmap_leader("fH", function() require("telescope.builtin").highlights() end, "Highlights")
nmap_leader("fj", function() require("telescope.builtin").jumplist() end, "Jumps")
nmap_leader("fk", function() require("telescope.builtin").keymaps() end, "Keymaps")
nmap_leader("fl", function() require("telescope.builtin").loclist() end, "Location List")
nmap_leader("fm", function() require("telescope.builtin").marks() end, "Marks")
nmap_leader("fq", function() require("telescope.builtin").quickfix() end, "Quickfix List")
nmap_leader("fs", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, "LSP Workspace Symbols")
nmap_leader("fb", function() require("telescope.builtin").git_branches() end, "Git Branches")
nmap_leader("fM", function() require("telescope.builtin").git_commits() end, "Git Commits")
nmap_leader("ft", "<cmd>TodoTelescope<cr>", "Todo")
nmap_leader("fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme")

-- git
nmap_leader("gD", "<cmd>CodeDiff<cr>", "CodeDiff")
nmap_leader("gd", "<cmd>CodeDiff file HEAD<cr>", "CodeDiff This File")
nmap_leader("gg", "<cmd>Neogit<cr>", "Show Neogit UI")

-- session
nmap_leader("s.", function() require("persistence").load() end, "Restore Session")
nmap_leader("ss", function() require("persistence").select() end,"Select Session")
nmap_leader("sr", function() require("persistence").load({ last = true }) end, "Restore Last Session")
nmap_leader("sd", function() require("persistence").stop() end, "Don't Save Current Session")

-- code
map_leader({"n", "v"}, "cf", function() require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000, }) end, "Format")
map({ "n", "v", "i" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })

-- lsp
nmap("gd",  function() require("telescope.builtin").lsp_definitions() end, "Goto Definition")
nmap("grr", function() require("telescope.builtin").lsp_references() end, "References")
nmap("gri", function() require("telescope.builtin").lsp_implementations() end, "Goto Implementation")
nmap("grt", function() require("telescope.builtin").lsp_type_definitions() end, "Goto T[y]pe Definition")
nmap("gai", function() require("telescope.builtin").lsp_incoming_calls() end, "C[a]lls Incoming")
nmap("gao", function() require("telescope.builtin").lsp_outgoing_calls() end, "C[a]lls Outgoing")

-- terminal
map({ "n", "t" }, "<c-/>", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal (Current Dir)" })

-- keywordprg
nmap_leader("K", "<cmd>norm! K<cr>", "Keywordprg")

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
nmap("]d", diagnostic_goto(true), "Next Diagnostic")
nmap("[d", diagnostic_goto(false), "Prev Diagnostic")
nmap("]e", diagnostic_goto(true, "ERROR"), "Next Error")
nmap("[e", diagnostic_goto(false, "ERROR"), "Prev Error")
nmap("]w", diagnostic_goto(true, "WARN"), "Next Warning")
nmap("[w", diagnostic_goto(false, "WARN"), "Prev Warning")

-- ui
nmap_leader("us", function() vim.opt.spell = not vim.o.spell end, "Toggle Spelling")
nmap_leader("uw", function() vim.opt.wrap = not vim.o.wrap end, "Toggle Wrap")
nmap_leader("ub", function() vim.opt.background = vim.o.background == "dark" and "light" or "dark" end, "Toggle Background")
nmap_leader("ug", function() vim.opt.list = not vim.o.list end, "Toggle Listchars")
nmap_leader("uC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, "Colorschemes")

-- plugin manager
nmap_leader("P", "<cmd>Lazy<cr>", "Plugin Manager")
--stylua: ignore end
