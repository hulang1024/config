--stylua: ignore start
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc) map("n", lhs, rhs, { desc = desc }) end
local map_leader = function(mode, suffix, rhs, desc) map(mode, "<leader>" .. suffix, rhs, { desc = desc }) end
local nmap_leader = function(suffix, rhs, desc) map_leader("n", suffix, rhs, desc) end
local xmap_leader = function(suffix, rhs, desc) map_leader("x", suffix, rhs, desc) end
local cmd = function (cmd) return "<cmd>" .. cmd .. "<cr>" end

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==")
map("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==")
map("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi")
map("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi")
map("v", "<a-j>", ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
map("v", "<a-k>", ":<c-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

map({ "n", "i", "s" }, "<esc>", function() vim.cmd("noh") return "<esc>" end, { expr = true })
nmap("Q", "<nop>")
vim.cmd([[
  cnoremap <c-a> <home>
  cnoremap <c-f> <right>
  cnoremap <c-b> <left>
  cnoremap <esc>b <s-left>
  cnoremap <esc>f <s-right>
]])

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
local diagnostic_goto = function(offset, severity)
  return function()
    vim.diagnostic.jump({
      count = offset * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      wrap = false,
      float = true,
    })
  end
end
nmap("]d", diagnostic_goto(1),            "Next diagnostic")
nmap("[d", diagnostic_goto(-1),           "Prev diagnostic")
nmap("]D", diagnostic_goto(vim._maxint),  "Last diagnostic")
nmap("[D", diagnostic_goto(-vim._maxint), "First diagnostic")
nmap("]e", diagnostic_goto(1, "ERROR"),   "Next error")
nmap("[e", diagnostic_goto(-1, "ERROR"),  "Prev error")
nmap("]w", diagnostic_goto(1, "WARN"),    "Next warning")
nmap("[w", diagnostic_goto(-1, "WARN"),   "Prev warning")

local wrap_prompt = function (prefix, escape)
  escape = escape or false
  local p =  prefix .. " > "
  return escape and p:gsub(" ", [[\ ]]) or p
end
local telescope_cmd = function(params, prompt)
  if not prompt or prompt == "" then
    prompt = params:match("%S+"):gsub("_", " "):gsub("^%l", string.upper)
  end
  return string.format( cmd("Telescope %s prompt_prefix=%s"), params, wrap_prompt(prompt, true))
end

-- code
map({ "n", "v", "i" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show code context actions" })

-- git
nmap("[h", cmd("Gitsigns prev_hunk"))
nmap("]h", cmd("Gitsigns next_hunk"))

-- lsp
nmap("gd",  telescope_cmd("lsp_definitions"),      "Goto definitions")
nmap("grr", telescope_cmd("lsp_references"),       "References")
nmap("gri", telescope_cmd("lsp_implementations"),  "Goto implementations")
nmap("grt", telescope_cmd("lsp_type_definitions"), "Goto type definitions")
nmap("grc", telescope_cmd("lsp_incoming_calls"),   "Incoming calls")
nmap("grC", telescope_cmd("lsp_outgoing_calls"),   "Outgoing calls")

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
  { "<leader>td",    group = "diagnostic" },
  { "<leader>tt",    group = "terminal" },
  { "<leader>d",     group = "debug" },
  { "<leader>c",     group = "code" },
  { "<leader>h",     group = "help" },
  { "<leader>a",     group = "avante" },
  { "<leader>H",     group = "home assistant" },
}

-- leader
nmap_leader("<cr>", "<c-^>", "Switch to last buffer")
nmap_leader(";", ":<c-u>lua = ", "Eval expression")
xmap_leader(";", ":lua<cr>", "Eval selection")
nmap_leader(" ", telescope_cmd("find_files", "Find file in project"), "Find file in project")
nmap_leader(".", telescope_cmd("find_files", "Find file"), "Find file")
nmap_leader(",", telescope_cmd("buffers", "Switch buffer"), "Switch Buffer")
nmap_leader(":", telescope_cmd("commands"), "Commands")
nmap_leader("/", telescope_cmd("live_grep"), "Grep")
nmap_leader("*", telescope_cmd("grep_string"), "Grep word")
xmap_leader("*", telescope_cmd("grep_string"), "Grep selection")
nmap_leader("'", telescope_cmd("resume"), "Resume last picker")
nmap_leader("K", cmd("norm! K"), "Keywordprg")
nmap_leader("P", cmd("Lazy"), "Plugin manager")

-- quit/session
nmap_leader("qq", cmd("qa"), "Quit neovim")
nmap_leader("qQ", cmd("qa!"), "Quit neovim without saving")
nmap_leader("qr", "<cmd>restart<cr><esc>", "Restart neovim")
nmap_leader("qR", function() require("persistence").load() end, "Restore session")
nmap_leader("ql", function() require("persistence").load({ last = true }) end, "Restore last session")
nmap_leader("qL", function() require("persistence").select() end,"Select session")
nmap_leader("qd", function() require("persistence").stop() end, "Don't save current session")

-- buffer
nmap_leader("bd", cmd("bd"), "Delete buffer")
nmap_leader("bD", cmd("%bd"), "Delete all buffer")

-- tab
nmap_leader("<tab>c", cmd("tabclose"))
for n = 1, 9 do
  nmap_leader("<tab>" .. n, n .. "gt", "Switch to " .. n .. "th tab")
end
nmap_leader("<tab>n", cmd("tabnew"), "New tab")

-- file
nmap_leader("fr", telescope_cmd("oldfiles", "Find recent file"), "Find recent file")
nmap_leader("fR", telescope_cmd("frecency", "Find frecency file"), "Find frecency file")
nmap_leader("fp", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
    prompt_prefix = wrap_prompt("Find private configuration")
  })
end, "Find private configuration")
nmap_leader("fP", function()
  require("telescope.builtin").find_files({
    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
    prompt_prefix = wrap_prompt("Find plugin file")
  })
end, "find plugin file")
nmap_leader("fg", telescope_cmd("git_files", "Find git file"), "Find git files")
nmap_leader("fd", function() vim.cmd("Oil" .. (vim.g.oil_float and " --float" or "")) end, "File explorer")
nmap_leader("fe", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, "Open file directory")
nmap_leader("fE", function() require("mini.files").open() end, "Open work directory")
nmap_leader("fs", cmd("up"), "Save file")
nmap_leader("fx", cmd("source %"), "Execute this file")

-- search
nmap_leader("sd", telescope_cmd("diagnostics bufnr=0", "Diagnostics (current buffer)"),            "Diagnostics (current buffer)")
nmap_leader("sD", telescope_cmd("diagnostics"),                                                    "Diagnostics")
nmap_leader("se", telescope_cmd("diagnostics bufnr=0 severity=ERROR", "Errors (current buffer)"),  "Errors (current buffer)")
nmap_leader("sE", telescope_cmd("diagnostics severity=ERROR", "Errors"),                           "Errors")
nmap_leader("sw", telescope_cmd("diagnostics bufnr=0 severity=WARN", "Warnings (current buffer)"), "Warnings (current buffer)")
nmap_leader("sW", telescope_cmd("diagnostics severity=WARN", "Warnings"),                          "Warnings")
nmap_leader("sg", telescope_cmd("live_grep grep_open_files=true", "Grep open buffers"), "Grep open buffers")
nmap_leader('s"', telescope_cmd("registers"),                                           "Registers")
nmap_leader("s/", telescope_cmd("search_history"),                                      "Search history")
nmap_leader("sa", telescope_cmd("autocommands"),                                        "Autocmds")
nmap_leader("sc", telescope_cmd("command_history"),                                     "Command history")
nmap_leader("sh", telescope_cmd("help_tags"),                                           "Help pages")
nmap_leader("sH", telescope_cmd("highlights"),                                          "Highlights")
nmap_leader("sj", telescope_cmd("jumplist"),                                            "Jumps")
nmap_leader("sQ", telescope_cmd("loclist"),                                             "Location list")
nmap_leader("sm", telescope_cmd("marks"),                                               "Marks")
nmap_leader("sq", telescope_cmd("quickfix"),                                            "Quickfix list")
nmap_leader("ss", telescope_cmd("lsp_document_symbols"),                                "Lsp document symbols")
nmap_leader("sS", telescope_cmd("lsp_dynamic_workspace_symbols"),                       "Lsp workspace symbols")
nmap_leader("sB", telescope_cmd("git_branches"),                                        "Git branches")
nmap_leader("sM", telescope_cmd("git_commits"),                                         "Git commits")
nmap_leader("st", telescope_cmd("todo-comments todo", "TODO"), "Todo")
nmap_leader("sT", telescope_cmd("todo-comments todo keywords=FIX,FIXME,BUG,FIXIT,ISSUE", "FIX/FIXME/BUG/FIXIT/ISSUE"), "Fix todo")

-- open
nmap_leader("od", cmd("Trouble diagnostics toggle filter.buf=0"),           "Buffer diagnostics (trouble)")
nmap_leader("oD", cmd("Trouble diagnostics toggle"),                        "Diagnostics (trouble)")
nmap_leader("oe", cmd("Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR filter.buf=0"), "Errors (trouble)")
nmap_leader("oE", cmd("Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR"), "Errors (trouble)")
nmap_leader("os", cmd("Trouble symbols toggle focus=false"),                "Symbols (trouble)")
nmap_leader("ol", cmd("Trouble lsp toggle focus=false win.position=right"), "Lsp definitions / references / ... (trouble)")
nmap_leader("oq", cmd("Trouble qflist toggle"),                             "Quickfix list (trouble)")
nmap_leader("oQ", cmd("Trouble loclist toggle"),                            "Location list (trouble)")
nmap_leader("ot", cmd("Trouble todo toggle"),                               "Todo (trouble)")
nmap_leader("oT", cmd("Trouble todo toggle filter={tag={FIX,FIXME,BUG,FIXIT,ISSUE}}"), "Fix todo (trouble)")

-- project
nmap_leader("pp", telescope_cmd("projects"), "Switch Project")

-- git
nmap_leader("gd", cmd("CodeDiff"),                     "CodeDiff")
nmap_leader("gD", cmd("CodeDiff file HEAD"),           "Codediff this file")
nmap_leader("gg", cmd("Neogit kind=floating"),         "Neogit status (float window)")
nmap_leader("gG", cmd("Neogit"),                       "Neogit status")
nmap_leader("gp", cmd("Gitsigns preview_hunk_inline"), "Preview hunk inline")
nmap_leader("ghs", cmd("Gitsigns stage_hunk"),         "Stage hunk")
nmap_leader("ghS", cmd("Gitsigns stage_buffer"),       "Stage buffer")
nmap_leader("ghr", cmd("Gitsigns reset_hunk"),         "Reset hunk")
nmap_leader("ghR", cmd("Gitsigns reset_buffer"),       "Reset buffer")

-- code
nmap_leader("cf", function()
  require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000 })
end, "Format file")
xmap_leader("cf", function()
  require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 1000 })
end, "Format selection")

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
nmap_leader("tn", function() vim.opt.relativenumber = not vim.o.relativenumber end, "Toggle relative number")
-- terminal
local function toggle_term(number, type)
  local last = ""
  local direction = type and ("direction=" .. type) or last
  vim.g.term_toggle_number = number
  vim.cmd(number .. 'ToggleTerm ' .. direction)
end
nmap_leader("tdl", function()
  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end, "Toggle virtual text")
nmap_leader("tds", function()
  vim.diagnostic.config({
    signs = not vim.diagnostic.config().signs,
  })
end, "Toggle signs")
nmap_leader("tts", function() toggle_term(vim.v.count1, "horizontal") end, "Toggle terminal horizontal")
nmap_leader("tta", function() toggle_term(vim.v.count1, "tab") end,        "Toggle terminal tab")
nmap_leader("ttf", function() toggle_term(vim.v.count1, "float") end,      "Toggle terminal float")
local function toggle_terminal()
  local number = 1
  if vim.v.count ~= 0 then
    number = vim.v.count
  elseif vim.o.filetype == "toggleterm" then
    number = vim.b.toggle_number
  else
    number = vim.g.term_toggle_number or 1
  end
  toggle_term(number)
end
map({ 'n', "t", "i" }, '<c-/>', toggle_terminal, { desc = "Toggle Terminal" })
map({ 'n', "t", "i" }, '<c-_>', toggle_terminal, { desc = "Toggle Terminal" })

-- debug
nmap_leader("db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
nmap_leader("dc", function() require("dap").continue() end,          "Continue")
nmap_leader("dg", function() require("dap").run_to_cursor() end,     "Run to cursor")
nmap_leader("dr", function() require("dap").restart() end,           "Restart")
nmap_leader("dq", function() require("dap").terminate() end,         "Terminate")
nmap_leader("dn", function() require("dap").step_over() end, "Step over")
nmap_leader("dp", function() require("dap").step_back() end, "Step back")
nmap_leader("di", function() require("dap").step_into() end, "Step into")
nmap_leader("do", function() require("dap").step_out() end,  "Step out")
nmap_leader("dk", function()
  require("dap.ui.widgets").hover()
end, "Hover")
nmap_leader("df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, "Centered float")
nmap_leader("dl", function()
  local server = require("osv").launch({ port = 8086 })
  if not server then
    vim.notify("OSV launch failed", vim.log.levels.WARN)
  else
    vim.notify(string.format("OSV listening on %s:%s", server.host, server.port), vim.log.levels.INFO)
  end
end, "Launch neovim lua adpater")

-- help
nmap_leader("hi", cmd("help"), "Info")
nmap_leader("hk", telescope_cmd("keymaps"), "Keymaps")
nmap_leader("hK", function()
  local leader = vim.g.mapleader or "\\"
  require("telescope.builtin").keymaps({
    lhs_filter = function(lhs)
      return vim.startswith(lhs, leader)
    end,
  })
end, "Leader keymaps")
nmap_leader("hh", ":<c-u>help ", "Help word")
nmap_leader("hc", function()
  require("telescope.builtin").colorscheme({
    ignore_builtins = true,
    enable_preview = true,
  })
end , "Colorschemes")

--stylua: ignore end
