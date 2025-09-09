return function()
  require("autosave").setup {
    enabled = false,
    events = { "InsertLeave", "TextChanged" },
    conditions = {
      exists = true,
      filename_is_not = {},
      filetype_is_not = {},
      modifiable = true,
    },
    prompt_message = function()
      return ""
    end,
    write_all_buffers = true,
    on_off_commands = true,
    clean_command_line_interval = 0,
  }
end
