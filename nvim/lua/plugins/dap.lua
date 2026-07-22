return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
    },
    lazy = true,
    config = function()
      local dap = require("dap")
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.listeners.after.event_initialized["user-dap"] = function(session)
        local name = session.config and session.config.name or "DAP"
        vim.notify("DAP attached: " .. name, vim.log.levels.INFO)
      end
      dap.listeners.after.event_terminated["user-dap"] = function()
        vim.notify("DAP session terminated", vim.log.levels.INFO)
      end
      dap.listeners.after.disconnect["user-dap"] = function()
        vim.notify("DAP disconnected", vim.log.levels.INFO)
      end
    end,
  },
}
