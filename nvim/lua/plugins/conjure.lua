return {
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python" },
    lazy = true,
    init = function()
      local repl_cmd = [[TermExec cmd="clojure -M:nrepl"]]
      vim.g["conjure#debug"] = false
      vim.g["conjure#mapping#doc_word"] = { "K" }
      vim.g["conjure#mapping#def_word"] = { "gd" }
      -- Use the same nREPL startup command for auto-repl and manual :Repl.
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "clojure -M:nrepl"
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true

      vim.api.nvim_create_user_command("Repl", function()
        vim.cmd(repl_cmd)
      end, { desc = "Start nREPL in ToggleTerm" })
      vim.api.nvim_create_user_command("ReplConnect", function()
        vim.cmd("ConjureConnect 127.0.0.1:7888")
      end, { desc = "Connect Conjure to nREPL :7888" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "clojure" },
        callback = function(event)
          local bufnr = event.buf
          vim.keymap.set({ "n" }, "<leader>;", ":ConjureEvalCurrentForm<cr>", { buf = bufnr })
          vim.keymap.set({ "x" }, "<leader>;", ":ConjureEvalVisual<cr>", { buf = bufnr })
          vim.keymap.set({ "n" }, "<leader>xw", ":ConjureEvalWord<cr>", { buf = bufnr })
        end,
      })
    end,
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          clojure = { "lazydev", "lsp", "path", "snippets", "buffer", "conjure" },
          fennel = { "lazydev", "lsp", "path", "snippets", "buffer", "conjure" },
          python = { "lazydev", "lsp", "path", "snippets", "buffer", "conjure" },
        },
        providers = {
          conjure = {
            name = "conjure",
            module = "blink.compat.source",
            score_offset = 50,
          },
        },
      },
    },
  },
}
