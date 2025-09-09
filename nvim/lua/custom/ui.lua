---@type LazyPluginSpec
return {
  "folke/lazy.nvim",
  lazy = false,
  priority = 1000,

  opts = function(_, opts)
    opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, {
      border = "rounded",
      title = "LazyVim Plugins",
      icons = {
        cmd = "",
        config = "",
        event = "",
        ft = "",
        init = "",
        keys = "",
        plugin = "",
        runtime = "",
        source = "",
        start = "",
        task = "",
      },
    })
    return opts
  end,
}
