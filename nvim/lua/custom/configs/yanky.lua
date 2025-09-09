local config = function()
  require("yanky").setup {
    preserve_cursor_position = {
      enabled = true,
    },
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 500,
    },
  }
end

return config
