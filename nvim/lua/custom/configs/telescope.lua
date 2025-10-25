return function()
    local telescope = require("telescope")
    local themes = require("telescope.themes")

    telescope.setup({
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.95,
                    height = 0.99,
                    preview_width = 0.7,
                },
            },
        },
        extensions = {
            undo = {},
            ["ui-select"] = themes.get_dropdown({
                previewer = true,
            }),
        },
    })

    -- Load Telescope extensions
    telescope.load_extension("undo")
    telescope.load_extension("refactoring")
    telescope.load_extension("yank_history")
    telescope.load_extension("fzf")
    telescope.load_extension("textcase")
    telescope.load_extension("package_info")
end
