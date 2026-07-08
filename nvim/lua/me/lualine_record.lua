local M = {}

M.lualine_section = {
  function()
    local reg = vim.fn.reg_recording()
    return reg == "" and "" or "recording @" .. reg
  end,
  color = function()
    local theme_color = require("lualine.utils.utils").extract_highlight_colors("DiagnosticError", "fg")
    return { fg = theme_color or "#e86671" }
  end,
}

local function init()
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    callback = function()
      require("lualine").refresh()
    end,
  })
end

init()

return M

