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
			-- When true, will show the completion window after typing a trigger character
			show_on_trigger_character = true,
			-- When both this and show_on_trigger_character are true, will show the completion window
			-- when the cursor comes after a trigger character when entering insert mode
			show_on_insert_on_trigger_character = true,
			-- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
			-- the completion window when the cursor comes after a trigger character when
			-- entering insert mode/accepting an item
			show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", ">" },
			-- or a function, similar to show_on_blocked_trigger_character
		},
		accept = {
			-- experimental auto-brackets support
			auto_brackets = {
				enabled = true,
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
		default = { "supermaven", "copilot", "lsp", "path", "snippets", "buffer" },

		per_filetype = {
			sql = { "snippets", "dadbod", "buffer" },
			mysql = { "snippets", "dadbod", "buffer" },
			text = { "dictionary" },
			markdown = { "lsp", "buffer", "thesaurus" },
		},
		-- add vim-dadbod-completion to your completion providers
		providers = {
			-- Use blink.compat for supermaven (bridges nvim-cmp sources to blink.cmp)
			supermaven = {
				name = "Supermaven",
				module = "blink.compat.source",
				score_offset = 90,
				opts = {
					name = "supermaven",
				},
			},
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100,
				async = true,
			},
			-- Use the thesaurus source
			thesaurus = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.thesaurus",
				-- All available options
				opts = {
					-- A score offset applied to returned items.
					-- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
					score_offset = 0,

					-- Default pointers define the lexical relations listed under each definition,
					-- see Pointer Symbols below.
					-- Default is as below ("antonyms", "similar to" and "also see").
					definition_pointers = { "!", "&", "^" },
				},
			},

			-- Use the dictionary source
			dictionary = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.dictionary",
				-- All available options
				opts = {
					-- The number of characters required to trigger completion.
					-- Set this higher if completion is slow, 3 is default.
					dictionary_search_threshold = 3,

					-- See above
					score_offset = 0,

					-- See above
					definition_pointers = { "!", "&", "^" },
				},
			},
		},
	},

	signature = { enabled = false },
}

return opts
