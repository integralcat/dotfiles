return {
	"saghen/blink.cmp",
	version = "1.*",

	opts = {
		cmdline = { enabled = true },

		keymap = {
			preset = "enter",
			-- next / previous item
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
		},

		completion = {
			trigger = {
				show_on_trigger_character = true,
				show_on_blocked_trigger_characters = { " ", "\n", "\t" },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				update_delay_ms = 300,
			},
			ghost_text = {
				enabled = true,
				show_with_menu = true,
			},
			menu = {
				auto_show = true,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust" },
	},
	opts_extend = { "sources.default" },
}
