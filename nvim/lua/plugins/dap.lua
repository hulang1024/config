return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
      -- Install only (no opts/config here). setup() must run after dap is loaded,
      -- because nvim-dap-virtual-text does require("dap") at module top-level.
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      {
        "ownself/nvim-dap-unity",
        build = function()
          require("nvim-dap-unity").install()
        end,
      },
    },
    lazy = true,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Unity C#: injects dap.adapters.unity + "Attach to Unity" into dap.configurations.cs
      require("nvim-dap-unity").setup({})

      if vim.g.dap_providers_launch_json_disabled then
        dap.providers.configs["dap.launch.json"] = nil
      end

      -- Prefer an already-visible source window when hitting a breakpoint.
      dap.defaults.fallback.switchbuf = "useopen,usetab,uselast"

      -- Layout 1 = Console (opened with the session).
      -- Layout 2 = IDEA-like Frames | Variables | Watches | Breakpoints (keymap).
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        layouts = {
          {
            elements = { "console" },
            size = 10,
            position = "bottom",
          },
          {
            elements = {
              { id = "stacks", size = 0.22 },
              { id = "scopes", size = 0.38 },
              { id = "watches", size = 0.20 },
              { id = "breakpoints", size = 0.20 },
            },
            size = 14,
            position = "bottom",
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
          enabled = true,
          element = "scopes",
        },
        ---@diagnostic disable-next-line: missing-fields
        floating = {
          border = "rounded",
        },
      })
      require("nvim-dap-virtual-text").setup({
        commented = false,
        virt_text_pos = "eol",
      })

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

      local function kill_java_debuggees()
        local pids, seen = {}, {}
        for _, line in ipairs(vim.fn.systemlist({ "pgrep", "-af", "agentlib:jdwp=transport=dt_socket,server=n" })) do
          local is_jdtls = line:find("eclipse.jdt.ls", 1, true)
            or line:find("lombok.jar", 1, true)
            or line:find("jdtls", 1, true)
          local pid = tonumber(line:match("^(%d+)"))
          if pid and not is_jdtls and not seen[pid] then
            seen[pid] = true
            table.insert(pids, pid)
            pcall(vim.fn.system, { "kill", "-KILL", "--", tostring(pid) })
            pcall(vim.uv.kill, pid, "sigkill")
          end
        end
        if #pids > 0 then
          print("Killed debuggee pid(s): " .. table.concat(pids, ", "), vim.log.levels.INFO)
        end
      end

      _G.DapTerminateAndKill = function()
        dap.terminate({
          all = true,
          hierarchy = true,
          disconnect_args = { terminateDebuggee = true },
          on_done = kill_java_debuggees,
        })
        kill_java_debuggees()
      end

      dap.listeners.after.event_initialized["user-dap"] = function(session)
        local name = session.config and session.config.name or "DAP"
        print("DAP attached: " .. name, vim.log.levels.INFO)
        dapui.open({ layout = 1 })
      end
      dap.listeners.after.event_terminated["user-dap"] = function()
        print("DAP session terminated", vim.log.levels.INFO)
        dapui.close()
      end
      dap.listeners.after.event_exited["user-dap"] = function()
        dapui.close()
      end
      dap.listeners.after.disconnect["user-dap"] = function()
        print("DAP disconnected", vim.log.levels.INFO)
        dapui.close()
      end
    end,
  },
}
