if vim.g.neovide then
  vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function ()
      vim.g.neovide_cursor_vfx_mode = "pixiedust"
      vim.g.neovide_position_animation_length = 0.15
      vim.g.neovide_cursor_animation_length = 0.15
    end
  })
end
