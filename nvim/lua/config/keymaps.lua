--stylua: ignore start
local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bi", function() Snacks.bufdelete.invisible() end, { desc = "Delete Invisible Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- tabs
map("n", "<leader><tab>0", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>$", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>l", "<cmd>tabs<cr>", { desc = "List Tabs" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })

map({ "i", "n", "s" }, "<esc>", function() vim.cmd("noh") return "<esc>" end, { expr = true, desc = "Escape" })

-- 保存文件
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File", silent = true })

-- keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

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
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- trouble
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
map("n", "<leader>xT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })

-- todo comments
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
map("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true })

-- code action
map("n", "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })

-- Code diff
map("n", "<leader>go", "<cmd>CodeDiff<cr>", { desc = "CodeDiff" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All", silent = true })

-- floating terminal
map("n", "<leader>ft", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map({ "n", "t" }, "<c-/>", function() Snacks.terminal.focus(nil, { cwd = vim.uv.cwd() }) end, { desc = "Terminal (Current Dir)" })

map("n", "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua" })
map("n", "<localleader>s", "<cmd>source %<cr>", { desc = "Source File" })

map("n", "<leader>ee", "<CMD>Oil --float<CR>", { desc = "Open parent directory (float window)" })
map("n", "<leader>eE", "<CMD>Oil<CR>", { desc = "Open parent directory" })
map("n", "<leader>ed", function() MiniFiles.open() end, { desc = "Directory" })
map("n", "<leader>ef", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = "File directory" })
--stylua: ignore end
