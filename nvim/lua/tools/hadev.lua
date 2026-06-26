local M = {}

function M.trigger_webhook(webhook_id)
  local _, curl = pcall(require, "plenary.curl")
  curl.post("http://192.168.1.100:8123/api/webhook/" .. webhook_id, {
    callback = function(response)
      if not response.status == 200 then
        print("请求失败")
      end
    end
  })
end

function M.toggle_light()
  M.trigger_webhook("-Gu-fnjgbtfWjgrtXshg_yNRK")
end

return M
