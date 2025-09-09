local options = {
	ensure_installed = {
		-- Neovim-related
		"lua",
		"vim",
		"vimdoc",

		-- Web development
		"html",
		"css",
		"tsx",
		"json",
		"javascript",
		"typescript",

		-- Backend & Systems languages
		"go",
		"gomod",
		"gowork",
		"gosum",
		"python",
		"c",
		"cpp",

		-- Build systems & Config
		"make",
		"cmake",
		"yaml",
		"toml",

		-- Other useful parsers
		"markdown",
		"markdown_inline",
		"regex",
		"bash",
		"dockerfile",

		-- Hyprland configs
		"hyprlang",
	},

	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

return options
