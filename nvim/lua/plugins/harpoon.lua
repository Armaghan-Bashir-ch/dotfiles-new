return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- IMPORTANT for new version
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require "harpoon"

    harpoon:setup() -- NEW API: `:` not `.`
  end,
}
