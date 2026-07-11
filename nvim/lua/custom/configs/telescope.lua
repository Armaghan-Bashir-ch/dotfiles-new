return function()
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.75,
                    height = 0.75,
                    preview_width = 0.75,
                },
            },
            preview = {
                treesitter = false,
            },
        },
        extensions = {
            undo = {},
        },
    })

    -- Load Telescope extensions
    telescope.load_extension("undo")
    telescope.load_extension("yank_history")
    telescope.load_extension("fzf")
    telescope.load_extension("textcase")
    telescope.load_extension("package_info")
end
