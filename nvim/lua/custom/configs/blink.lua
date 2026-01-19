local opts = {
	cmdline = {
		keymap = {
			preset = "super-tab",
			["<Tab>"] = { "show", "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},
		completion = {
			menu = {
				auto_show = false,
			},
		},
	},
	completion = {
		trigger = {
			-- Only show completion when Tab is pressed - extreme speed
			show_on_trigger_character = false,
			show_on_insert_on_trigger_character = false,
		},
		accept = {
			auto_brackets = {
				enabled = false,
			},
		},
		menu = {
			scrollbar = false,
			border = "rounded",
			draw = {
				columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				border = "rounded",
				max_width = 60,
				max_height = 15,
			},
		},
	},
	keymap = {
		preset = "super-tab",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<A-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },
		-- TODO: replace with a loop
		["<A-1>"] = {
			function(cmp)
				cmp.accept { index = 1 }
			end,
		},
		["<A-2>"] = {
			function(cmp)
				cmp.accept { index = 2 }
			end,
		},
		["<A-3>"] = {
			function(cmp)
				cmp.accept { index = 3 }
			end,
		},
		["<A-4>"] = {
			function(cmp)
				cmp.accept { index = 4 }
			end,
		},
		["<A-5>"] = {
			function(cmp)
				cmp.accept { index = 5 }
			end,
		},
		["<A-6>"] = {
			function(cmp)
				cmp.accept { index = 6 }
			end,
		},
		["<A-7>"] = {
			function(cmp)
				cmp.accept { index = 7 }
			end,
		},
		["<A-8>"] = {
			function(cmp)
				cmp.accept { index = 8 }
			end,
		},
		["<A-9>"] = {
			function(cmp)
				cmp.accept { index = 9 }
			end,
		},
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	sources = {
		-- Minimal sources for extreme speed - no buffer/dictionary/thesaurus scanning
		default = { "supermaven", "lsp", "path", "snippets" },

		per_filetype = {
			sql = { "snippets", "dadbod" },
			mysql = { "snippets", "dadbod" },
			text = { "lsp", "path" },
			markdown = { "lsp", "snippets", "path" },
		},
		-- Performance-optimized providers
		providers = {
			supermaven = {
				name = "Supermaven",
				module = "blink.compat.source",
				score_offset = 90,
			},
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
		},
	},

	signature = { enabled = false },
}

return opts
