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
  { "<leader><tab>", group = "tab" },
  { "<leader>e", group = "explorer", icon = " " },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>t", group = "terminal" },
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
nmap_leader("<space>", "<cmd>b #<cr>", "Alternate Buffer")
nmap_leader("bd", "<cmd>bd<cr>", "Delete Buffer")
nmap_leader("bD", "<cmd>bd<cr>", "Delete Buffer and Window")

-- tab
nmap("[t", "<cmd>tabprev<cr>", "Previous Tab")
nmap("]t", "<cmd>tabnext<cr>", "Next Tab")
nmap_leader("<tab>c", "<cmd>tabclose<cr>", "Close Tab")
nmap_leader("<tab>o", "<cmd>tabonly<cr>", "Close Other Tabs")
nmap_leader("<tab>l", "<cmd>tabs<cr>", "List Tabs")
nmap_leader("<tab>n", "<cmd>tabnew<cr>", "New Tab")

-- explorer
nmap("-", "<cmd>Oil --float<cr>", "Open parent directory (float window)")
nmap_leader("-", "<cmd>Oil<cr>", "Open parent directory")
nmap_leader("ed", function() require("mini.files").open() end, "File Explorer (cwd)")
nmap_leader("ef", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, "File Explorer")
nmap_leader("ex", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           "Diagnostics (Buffer)(Trouble)")
nmap_leader("eX", "<cmd>Trouble diagnostics toggle<cr>",                        "Diagnostics (Trouble)")
nmap_leader("es", "<cmd>Trouble symbols toggle focus=false<cr>",                "Symbols (Trouble)")
nmap_leader("el", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references / ... (Trouble)")
nmap_leader("eq", "<cmd>Trouble qflist toggle<cr>",                             "Quickfix List (Trouble)")
nmap_leader("eQ", "<cmd>Trouble loclist toggle<cr>",                            "Location List (Trouble)")
nmap_leader("et", "<cmd>Trouble todo toggle<cr>",                               "Todo (Trouble)")
nmap_leader("eT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", "Todo/Fix/Fixme (Trouble)")

-- fuzzy find
local function find_root()
  return require("mini.misc").find_root(0, vim.g.root_names or { ".root", ".git" })
end
local function find_workspace_files()
  require("telescope.builtin").find_files({
    cwd = find_root(),
    hidden = true,
  })
end

nmap_leader(",",  "<cmd>Telescope buffers<cr>", "Buffers")
nmap_leader(";",  find_workspace_files, "Workspace Files")
nmap_leader(".",  "<cmd>Telescope frecency<cr>", "Frecency Files")
nmap_leader(":",  "<cmd>Telescope command_history<cr>", "Command History")
nmap_leader("/",  "<cmd>Telescope live_grep<cr>", "Grep Workspace")
nmap_leader("'",  "<cmd>Telescope lsp_document_symbols<cr>", "LSP Document Symbols")
nmap_leader("*",  "<cmd>Telescope grep_string<cr>", "Grep Word/Selection")
xmap_leader("*",  "<cmd>Telescope grep_string<cr>", "Grep Word/Selection")
nmap_leader("r",  "<cmd>Telescope resume<cr>", "Resume Last Picker")
nmap_leader("fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, "Config File")
nmap_leader("fP", function() require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, "Plugin File")
nmap_leader("fr", "<cmd>Telescope oldfiles<cr>", "Recent Files")
nmap_leader("fp", "<cmd>Telescope projects<cr>", "Projects")
nmap_leader("fg", "<cmd>Telescope live_grep grep_open_files=true<cr>", "Grep Open Buffers")
nmap_leader("fG", "<cmd>Telescope git_files<cr>", "Git Files")
nmap_leader('f"', "<cmd>Telescope registers<cr>", "Registers")
nmap_leader("f/", "<cmd>Telescope search_history<cr>", "Search History")
nmap_leader("fa", "<cmd>Telescope autocommands<cr>", "Autocmds")
nmap_leader("fC", "<cmd>Telescope commands<cr>", "Commands")
nmap_leader("fd", "<cmd>Telescope diagnostics bufnr=0<cr>", "Diagnostics (Buffer)")
nmap_leader("fD", "<cmd>Telescope diagnostics<cr>", "Diagnostics")
nmap_leader("fe", "<cmd>Telescope diagnostics bufnr=0 severity=ERROR<cr>", "Errors (Buffer)")
nmap_leader("fE", "<cmd>Telescope diagnostics severity=ERROR<cr>", "Errors")
nmap_leader("fw", "<cmd>Telescope diagnostics bufnr=0 severity=WARN<cr>", "Warnings (Buffer)")
nmap_leader("fW", "<cmd>Telescope diagnostics severity=WARN<cr>", "Warnings")
nmap_leader("fh", "<cmd>Telescope help_tags<cr>", "Help Pages")
nmap_leader("fH", "<cmd>Telescope highlights<cr>", "Highlights")
nmap_leader("fj", "<cmd>Telescope jumplist<cr>", "Jumps")
nmap_leader("fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
nmap_leader("fl", "<cmd>Telescope loclist<cr>", "Location List")
nmap_leader("fm", "<cmd>Telescope marks<cr>", "Marks")
nmap_leader("fq", "<cmd>Telescope quickfix<cr>", "Quickfix List")
nmap_leader("fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "LSP Workspace Symbols")
nmap_leader("fb", "<cmd>Telescope git_branches<cr>", "Git Branches")
nmap_leader("fM", "<cmd>Telescope git_commits<cr>", "Git Commits")
nmap_leader("ft", "<cmd>TodoTelescope<cr>", "Todo")
nmap_leader("fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme")

-- git
nmap_leader("gD", "<cmd>CodeDiff<cr>", "CodeDiff")
nmap_leader("gd", "<cmd>CodeDiff file HEAD<cr>", "CodeDiff This File")
nmap_leader("gg", "<cmd>Neogit<cr>", "Open Neogit")
nmap_leader("gG", "<cmd>Neogit kind=floating<cr>", "Open Neogit (float window)")

-- session
nmap_leader("s.", function() require("persistence").load() end, "Restore Session")
nmap_leader("ss", function() require("persistence").select() end,"Select Session")
nmap_leader("sr", function() require("persistence").load({ last = true }) end, "Restore Last Session")
nmap_leader("sd", function() require("persistence").stop() end, "Don't Save Current Session")

-- code
map_leader({"n", "v"}, "cf", function() require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000, }) end, "Format")

-- lsp
map({ "n", "v", "i" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })
nmap("gd",  "<cmd>Telescope lsp_definitions<cr>", "Goto Definition")
nmap("grr", "<cmd>Telescope lsp_references<cr>", "References")
nmap("gri", "<cmd>Telescope lsp_implementations<cr>", "Goto Implementation")
nmap("grt", "<cmd>Telescope lsp_type_definitions<cr>", "Goto T[y]pe Definition")
nmap("grc", "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming Calls")
nmap("grC", "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing Calls")

-- terminal
local function toggle_term(number, type)
  -- 为空则表示最后方向，否则设置新方向
  local direction = type and ("direction=" .. type) or ""
  vim.g.term_toggle_number = number
  vim.cmd(number .. 'ToggleTerm dir=' .. find_root() .. " " .. direction)
end
nmap_leader("ts", function() toggle_term(vim.v.count1, "horizontal") end, "Toggle Terminal(Horizontal) (Root Dir)")
nmap_leader("ta", function() toggle_term(vim.v.count1, "tab") end,        "Toggle Terminal(Tab) (Root Dir)")
nmap_leader("tf", function() toggle_term(vim.v.count1, "float") end,      "Toggle Terminal(Float) (Root Dir)")
map({ 'n', "t", "i" }, '<c-/>', function()
  local number = 1
  if vim.v.count ~= 0 then
    number = vim.v.count
  elseif vim.o.filetype == "toggleterm" then
    number = vim.b.toggle_number
  else
    number = vim.g.term_toggle_number or 1
  end
  toggle_term(number)
end, { desc = "Toggle Terminal (Root Dir)" })

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
nmap("]d", diagnostic_goto(true),           "Next Diagnostic")
nmap("[d", diagnostic_goto(false),          "Prev Diagnostic")
nmap("]e", diagnostic_goto(true, "ERROR"),  "Next Error")
nmap("[e", diagnostic_goto(false, "ERROR"), "Prev Error")
nmap("]w", diagnostic_goto(true, "WARN"),   "Next Warning")
nmap("[w", diagnostic_goto(false, "WARN"),  "Prev Warning")

-- ui
nmap_leader("us", function() vim.opt.spell = not vim.o.spell end, "Toggle Spelling")
nmap_leader("uw", function() vim.opt.wrap = not vim.o.wrap end, "Toggle Wrap")
nmap_leader("ub", function() vim.opt.background = vim.o.background == "dark" and "light" or "dark" end, "Toggle Background")
nmap_leader("ug", function() vim.opt.list = not vim.o.list end, "Toggle Listchars")
nmap_leader("uc", "<cmd>Telescope colorscheme enable_preview=true<cr>", "Colorschemes")

-- plugin manager
nmap_leader("P", "<cmd>Lazy<cr>", "Plugin Manager")
--stylua: ignore end
