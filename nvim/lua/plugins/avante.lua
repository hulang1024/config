return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      selector = {
        provider = "telescope",
      },
      provider = "cursor",
      acp_providers = {
        ["cursor"] = {
          command = "agent.cmd",
          args = {
            "acp",
            -- "--model", "composer-2.5",
          },
          on_exit = function(code, signal)
            if code ~= 0 then
              vim.notify("cursor-agent 已退出。code: " .. tostring(code), vim.log.levels.WARN)
            end
          end,
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "AvanteInput",
        callback = function()
          vim.opt_local.cursorline = false
        end,
      })

      -- agent 可能已改文件：回复结束时 checktime
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("my_avante_checktime", { clear = true }),
        pattern = "AvanteViewBufferUpdated",
        callback = function()
          vim.cmd("checktime")
        end,
      })
    end,
  },
}
