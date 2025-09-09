routes = {
  {
    filter = {
      event = "mode_changed",
    },
    view = "mini",
    opts = {
      skip = false,
      format = function(mode)
        local colors = {
          n = "#8aadf4",
          i = "#a6da95",
          v = "#f5a97f",
          V = "#f5a97f",
          c = "#f4dbd6",
        }
        local hl = "%#NoiceFormatMode#"
        local text = mode:upper() .. " MODE"
        vim.api.nvim_set_hl(0, "NoiceFormatMode", { fg = colors[mode] or "#ffffff", bold = true })
        return hl .. " " .. text .. " "
      end,
    },
  },
}
