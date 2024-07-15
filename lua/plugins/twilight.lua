return {
	"folke/twilight.nvim",
	cmd = {
		"Twilight",
		"TwilightEnable",
		"TwilightDisable",
	},
	opts = {
		context = 10,
		expand = {
			"function",
			"function_definition", -- python
			"function_item", -- rust
			"method",
		},
	},
}
