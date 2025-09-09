require("lualine").setup {
  sections = {
    lualine_a = {
      {
        "mode",
        color = function()
          local mode_color = {
            n = "#ff9e64",
            i = "#9ece6a",
            v = "#7aa2f7",
            [""] = "#7aa2f7",
            V = "#7aa2f7",
            c = "#e0af68",
            no = "#ff9e64",
            s = "#f7768e",
            S = "#f7768e",
            [""] = "#f7768e",
            ic = "#9ece6a",
            R = "#bb9af7",
            Rv = "#bb9af7",
            cv = "#e0af68",
            ce = "#e0af68",
            r = "#bb9af7",
            rm = "#bb9af7",
            ["r?"] = "#bb9af7",
            ["!"] = "#e0af68",
            t = "#2ac3de",
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
      },
    },
  },
}
