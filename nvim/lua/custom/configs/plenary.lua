local config = function()
  local last_update_time = 0

  local function update()
    local current_time = os.time()
    if current_time - last_update_time < 120 then
      return
    end
    last_update_time = current_time
    require("custom.utils").updateWakatimeStats()
  end

  vim.api.nvim_create_user_command("FetchWakaTime", update, {})

  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = update,
    desc = "Fetch WakaTime stats on cursor hold",
  })
end

return config
