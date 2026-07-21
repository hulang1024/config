--stylua: ignore start
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc) map("n", lhs, rhs, { desc = desc }) end
local map_leader = function(mode, suffix, rhs, desc) map(mode, "<leader>" .. suffix, rhs, { desc = desc }) end
local nmap_leader = function(suffix, rhs, desc) map_leader("n", suffix, rhs, desc) end
local xmap_leader = function(suffix, rhs, desc) map_leader("x", suffix, rhs, desc) end

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==")
map("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==")
map("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi")
map("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi")
map("v", "<a-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
map("v", "<a-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

map({ "n", "i", "s" }, "<esc>", function() vim.cmd("noh") return "<esc>" end, { expr = true })

nmap("Q", "<nop>")
nmap("<localleader>s", "<cmd>source %<cr>", "Source file")

-- window
nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")
nmap("<tab>", function()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd p")
  if vim.api.nvim_get_current_win() == cur_win then
    vim.cmd("wincmd w")
  end
end)

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
nmap("]d", diagnostic_goto(true),           "Next diagnostic")
nmap("[d", diagnostic_goto(false),          "Prev diagnostic")
nmap("]e", diagnostic_goto(true, "ERROR"),  "Next error")
nmap("[e", diagnostic_goto(false, "ERROR"), "Prev error")
nmap("]w", diagnostic_goto(true, "WARN"),   "Next warning")
nmap("[w", diagnostic_goto(false, "WARN"),  "Prev warning")

_G.leader_group_keys = {
  { "<leader>q",     group = "quit/session" },
  { "<leader>b",     group = "buffer" },
  { "<leader><tab>", group = "tab" },
  { "<leader>f",     group = "file" },
  { "<leader>s",     group = "search" },
  { "<leader>o",     group = "open" },
  { "<leader>p",     group = "project" },
  { "<leader>g",     group = "git" },
  { "<leader>t",     group = "toggle" },
  { "<leader>c",     group = "code" },
  { "<leader>h",     group = "help" },
  { "<leader>a",     group = "avante" },
  { "<leader>H",     group = "home assistant" },
  { "gr",            group = "lsp" },
}

-- keywordprg
nmap_leader("K", "<cmd>norm! K<cr>", "Keywordprg")

-- plugin manager
nmap_leader("P", "<cmd>Lazy<cr>", "Plugin manager")

-- quit/session
nmap_leader("qq", "<cmd>qa<cr>", "Quit neovim")
nmap_leader("qQ", "<cmd>qa!<cr>", "Quit neovim without saving")
nmap_leader("qr", "<cmd>restart<cr><esc>", "Restart neovim")
nmap_leader("qR", function() require("persistence").load() end, "Restore session")
nmap_leader("ql", function() require("persistence").load({ last = true }) end, "Restore last session")
nmap_leader("qL", function() require("persistence").select() end,"Select session")
nmap_leader("qd", function() require("persistence").stop() end, "Don't save current session")

-- buffer
nmap_leader("bd", "<cmd>bd<cr>", "Delete buffer")
nmap_leader("bD", "<cmd>%bd<cr>", "Delete all buffer")

-- tab
nmap_leader("<tab>c", "<cmd>tabclose<cr>")
for n = 1, 9 do
  nmap_leader("<tab>" .. n, n .. "gt", "Switch to " .. n .. "th tab")
end
nmap_leader("<tab>n", "<cmd>tabnew<cr>", "New tab")

-- leader
nmap_leader("<cr>", "<c-^>", "Switch to last buffer")
nmap_leader(";", ":lua = ", "Eval expression")
nmap_leader(" ", function() require("telescope.builtin").find_files({ hidden = true }) end, "Find project files")
nmap_leader(".", function() require("telescope.builtin").find_files({ hidden = true }) end, "Find files")
nmap_leader(",", "<cmd>Telescope buffers<cr>", "Buffers")
nmap_leader(":", "<cmd>Telescope commands<cr>", "Commands")
nmap_leader("/", "<cmd>Telescope live_grep<cr>", "Grep")
nmap_leader("*", "<cmd>Telescope grep_string<cr>", "Grep word")
xmap_leader("*", "<cmd>Telescope grep_string<cr>", "Grep selection")
nmap_leader("'", "<cmd>Telescope resume<cr>", "Resume last picker")

-- file
nmap_leader("fr", "<cmd>Telescope oldfiles<cr>", "Recent files")
nmap_leader("fR", "<cmd>Telescope frecency<cr>", "Frecency files")
nmap_leader("fp", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, "Config file")
nmap_leader("fP", function() require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, "Plugin file")
nmap_leader("fg", "<cmd>Telescope git_files<cr>", "Git files")
nmap_leader("fd", function() vim.cmd("Oil" .. (vim.g.oil_float and " --float" or "")) end, "Open directory")
nmap_leader("fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, "File explorer")
nmap_leader("fE", function() require("mini.files").open() end, "File explorer (cwd)")
nmap_leader("fs", "<cmd>up<cr>", "Save file")

-- search
nmap_leader("sg", "<cmd>Telescope live_grep grep_open_files=true<cr>",     "Grep open buffers")
nmap_leader('s"', "<cmd>Telescope registers<cr>",                          "Registers")
nmap_leader("s/", "<cmd>Telescope search_history<cr>",                     "Search history")
nmap_leader("sa", "<cmd>Telescope autocommands<cr>",                       "Autocmds")
nmap_leader("sC", "<cmd>Telescope command_history<cr>",                    "Command history")
nmap_leader("sd", "<cmd>Telescope diagnostics bufnr=0<cr>",                "Diagnostics (buffer)")
nmap_leader("sD", "<cmd>Telescope diagnostics<cr>",                        "Diagnostics")
nmap_leader("se", "<cmd>Telescope diagnostics bufnr=0 severity=ERROR<cr>", "Errors (buffer)")
nmap_leader("sE", "<cmd>Telescope diagnostics severity=ERROR<cr>",         "Errors")
nmap_leader("sw", "<cmd>Telescope diagnostics bufnr=0 severity=WARN<cr>",  "Warnings (buffer)")
nmap_leader("sW", "<cmd>Telescope diagnostics severity=WARN<cr>",          "Warnings")
nmap_leader("sh", "<cmd>Telescope help_tags<cr>",                          "Help pages")
nmap_leader("sH", "<cmd>Telescope highlights<cr>",                         "Highlights")
nmap_leader("sj", "<cmd>Telescope jumplist<cr>",                           "Jumps")
nmap_leader("sQ", "<cmd>Telescope loclist<cr>",                            "Location list")
nmap_leader("sm", "<cmd>Telescope marks<cr>",                              "Marks")
nmap_leader("sq", "<cmd>Telescope quickfix<cr>",                           "Quickfix list")
nmap_leader("ss", "<cmd>Telescope lsp_document_symbols<cr>",               "Lsp document symbols")
nmap_leader("sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",      "Lsp workspace symbols")
nmap_leader("sB", "<cmd>Telescope git_branches<cr>",                       "Git branches")
nmap_leader("sM", "<cmd>Telescope git_commits<cr>",                        "Git commits")
nmap_leader("st", "<cmd>TodoTelescope<cr>",                                "Todo")
nmap_leader("sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",        "Todo/fix/fixme")

-- open
nmap_leader("od", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           "Buffer diagnostics (trouble)")
nmap_leader("oD", "<cmd>Trouble diagnostics toggle<cr>",                        "Diagnostics (trouble)")
nmap_leader("oe", "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR filter.buf=0<cr>", "Errors (trouble)")
nmap_leader("oE", "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>", "Errors (trouble)")
nmap_leader("os", "<cmd>Trouble symbols toggle focus=false<cr>",                "Symbols (trouble)")
nmap_leader("ol", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "Lsp definitions / references / ... (trouble)")
nmap_leader("oq", "<cmd>Trouble qflist toggle<cr>",                             "Quickfix list (trouble)")
nmap_leader("oQ", "<cmd>Trouble loclist toggle<cr>",                            "Location list (trouble)")
nmap_leader("ot", "<cmd>Trouble todo toggle<cr>",                               "Todo (trouble)")
nmap_leader("oT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", "Todo/fix/fixme (trouble)")

-- project
nmap_leader("pp", "<cmd>Telescope projects<cr>",                           "Switch Project")

-- git
nmap_leader("gd", "<cmd>CodeDiff<cr>",                     "CodeDiff")
nmap_leader("gD", "<cmd>CodeDiff file HEAD<cr>",           "Codediff this file")
nmap_leader("gg", "<cmd>Neogit kind=floating<cr>",         "Open neogit (float window)")
nmap_leader("gG", "<cmd>Neogit<cr>",                       "Open Neogit")
nmap_leader("gp", "<cmd>Gitsigns preview_hunk_inline<cr>", "Preview hunk inline")
nmap_leader("ghs", "<cmd>Gitsigns stage_hunk<cr>",         "Stage hunk")
nmap_leader("ghS", "<cmd>Gitsigns stage_buffer<cr>",       "Stage buffer")
nmap_leader("ghr", "<cmd>Gitsigns reset_hunk<cr>",         "Reset hunk")
nmap_leader("ghR", "<cmd>Gitsigns reset_buffer<cr>",       "Reset buffer")
nmap("[h", "<cmd>Gitsigns prev_hunk<cr>")
nmap("]h", "<cmd>Gitsigns next_hunk<cr>")

-- code
map_leader({"n", "v"}, "cf", function() require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000, }) end, "Format")
map({ "n", "v", "i" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show code context actions" })

-- lsp
nmap("gd",  "<cmd>Telescope lsp_definitions<cr>",      "Goto definitions")
nmap("grr", "<cmd>Telescope lsp_references<cr>",       "References")
nmap("gri", "<cmd>Telescope lsp_implementations<cr>",  "Goto implementations")
nmap("grt", "<cmd>Telescope lsp_type_definitions<cr>", "Goto type definitions")
nmap("grc", "<cmd>Telescope lsp_incoming_calls<cr>",   "Incoming calls")
nmap("grC", "<cmd>Telescope lsp_outgoing_calls<cr>",   "Outgoing calls")

-- toggle
nmap_leader("ts", function() vim.opt.spell = not vim.o.spell end, "Toggle spelling")
nmap_leader("tw", function() vim.opt.wrap = not vim.o.wrap end, "Toggle wrap")
nmap_leader("tb", function()
  vim.g.auto_background = false
  vim.api.nvim_exec_autocmds("User", { pattern = "ToggleBackground" })
end, "Toggle background")
nmap_leader("tB", function()
  vim.g.auto_background = not vim.g.auto_background
  vim.notify("Auto Backgrond " .. (vim.g.auto_background and "enabled" or "disabled"))
end, "Toggle auto background")
nmap_leader("tm", function()
  if vim.o.mouse == "" then
    vim.opt.mouse = "a"
  else
    vim.opt.mouse = ""
  end
  vim.notify("Mouse " .. (vim.o.mouse ~= "" and "enabled" or "disabled"))
end, "Toggle mouse")
nmap_leader("tg", function() vim.opt.list = not vim.o.list end, "Toggle listchars")
nmap_leader("tf", function() vim.g.oil_float = not vim.g.oil_float end, "Toggle oil float")
-- terminal
local function toggle_term(number, type)
  -- 为空则表示最后方向，否则设置新方向
  local direction = type and ("direction=" .. type) or ""
  vim.g.term_toggle_number = number
  vim.cmd(number .. 'ToggleTerm ' .. direction)
end
nmap_leader("tts", function() toggle_term(vim.v.count1, "horizontal") end, "Toggle terminal horizontal")
nmap_leader("tta", function() toggle_term(vim.v.count1, "tab") end,        "Toggle terminal tab")
nmap_leader("ttf", function() toggle_term(vim.v.count1, "float") end,      "Toggle terminal float")
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
end, { desc = "Toggle Terminal" })

-- help
nmap_leader("hi", "<cmd>help<cr>", "Info")
nmap_leader("hk", "<cmd>Telescope keymaps<cr>", "Keymaps")
nmap_leader("hh", ":help ", "Help word")
nmap_leader("hc", function()
  local colors = vim.fn.getcompletion("", "color")
  local lazy = package.loaded["lazy.core.util"]
  if lazy and lazy.get_unloaded_rtp then
    for _, f in ipairs(vim.fn.globpath(table.concat(lazy.get_unloaded_rtp(""), ","), "colors/*", true, true)) do
      colors[#colors + 1] = vim.fn.fnamemodify(f, ":t:r")
    end
  end
  require("telescope.builtin").colorscheme({
    ignore_builtins = true,
    enable_preview = true,
    colors = vim.fn.uniq(vim.fn.sort(colors)),
  })
end , "Colorschemes")

--stylua: ignore end
