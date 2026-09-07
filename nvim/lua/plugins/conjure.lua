return {
  {
    "Olical/conjure",
    ft = { "clojure", "fennel" },
    cmd = {
      "ConjureConnect",
      "ConjureEvalCurrentForm",
      "ConjureEvalVisual",
      "ConjureEvalWord",
    },
    lazy = true,
    init = function()
      local repl_cmd = "clojure -M:nrepl"
      vim.g["conjure#debug"] = false
      -- vim.g["conjure#mapping#doc_word"] = { "K" }
      -- vim.g["conjure#mapping#def_word"] = { "gd" }
      -- Keep auto-repl off by default; :Repl will trigger it manually.
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = repl_cmd
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true

      vim.api.nvim_create_user_command("Repl", function()
        vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
        vim.cmd("ConjureConnect")
        vim.defer_fn(function()
          vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
        end, 1500)
      end, { desc = "Manually trigger Conjure auto-repl without terminal" })
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
          fennel = { "lazydev", "lsp", "path", "snippets", "buffer" },
          python = { "lazydev", "lsp", "path", "snippets", "buffer" },
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
