local function trigger_webhook(webhook_id)
  local curl = require("plenary.curl")
  curl.post("http://192.168.1.100:8123/api/webhook/" .. webhook_id, {
    callback = function(response)
      if not response.status == 200 then
        print("请求失败")
      end
    end,
  })
end

local function toggle_light()
  trigger_webhook("-Gu-fnjgbtfWjgrtXshg_yNRK")
end

vim.keymap.set("n", "<leader>Hl", toggle_light, { desc = "开关卧室吸顶灯" })
