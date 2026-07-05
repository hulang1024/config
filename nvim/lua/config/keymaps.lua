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

-- Buffers
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape" })

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

-- lazy
map({ "n", "x" }, "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy", silent = true })

-- code action
map({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Show Code Context Actions" })

-- Code diff
map({ "n", "v" }, "<leader>go", "<Cmd>CodeDiff<CR>", { desc = "CodeDiff" })

-- quit
map({ "n", "x" }, "<leader>qq", "<Cmd>qa<CR>", { desc = "Quit All", silent = true })

-- floating terminal
map("n", "<leader>ft", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal.focus(nil, { cwd = vim.uv.cwd() })
end, { desc = "Terminal (Current Dir)" })

map({ "n", "x" }, "<localleader>r", function()
  Snacks.debug.run()
end, { desc = "Run Lua" })
map({ "n", "v" }, "<localleader>s", "<Cmd>source %<CR>", { desc = "Source File" })

map({ "n", "v" }, "<leader>cd", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(dir)
  vim.notify(dir, vim.log.levels.INFO)
end, { desc = "切换目录 (当前文件目录)" })
