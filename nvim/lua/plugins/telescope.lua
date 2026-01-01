return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      preview = {
        treesitter = false,
      },
      layout_config = {
        horizontal = { width = 0.9, height = 0.8 },
        vertical = { width = 0.5 },
      },
      sorting_strategy = "ascending",
      winblend = 10,
      prompt_prefix = "🔍 ",
      selection_caret = " ",
      borderchars = {
        prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
  },
}
