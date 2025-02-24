return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			accept = {
				dot_repeat = true,
			},
		},
		keymap = {
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
		},
	},
}
