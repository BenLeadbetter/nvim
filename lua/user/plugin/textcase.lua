return {
	"johmsalas/text-case.nvim",
	keys = {
		{
			"<leader>tcu",
			'<cmd>lua require("textcase").current_word("to_upper_case")<cr>',
			desc = "to_upper_case",
		},
		{
			"<leader>tcu",
			'<cmd>lua require("textcase").current_word("to_upper_case")<cr>',
			desc = "to_upper_case",
		},
		{
			"<leader>tcl",
			'<cmd>lua require("textcase").current_word("to_lower_case")<cr>',
			desc = "to_lower_case",
		},
		{
			"<leader>tcs",
			'<cmd>lua require("textcase").current_word("to_snake_case")<cr>',
			desc = "to_snake_case",
		},
		{
			"<leader>tcd",
			'<cmd>lua require("textcase").current_word("to_dash_case")<cr>',
			desc = "to_dash_case",
		},
		{
			"<leader>tcn",
			'<cmd>lua require("textcase").current_word("to_constant_case")<cr>',
			desc = "to_constant_case",
		},
		{
			"<leader>tcd",
			'<cmd>lua require("textcase").current_word("to_dot_case")<cr>',
			desc = "to_dot_case",
		},
		{
			"<leader>tca",
			'<cmd>lua require("textcase").current_word("to_phrase_case")<cr>',
			desc = "to_phrase_case",
		},
		{
			"<leader>tcc",
			'<cmd>lua require("textcase").current_word("to_camel_case")<cr>',
			desc = "to_camel_case",
		},
		{
			"<leader>tcp",
			'<cmd>lua require("textcase").current_word("to_pascal_case")<cr>',
			desc = "to_pascal_case",
		},
		{
			"<leader>tct",
			'<cmd>lua require("textcase").current_word("to_title_case")<cr>',
			desc = "to_title_case",
		},
		{
			"<leader>tcf",
			'<cmd>lua require("textcase").current_word("to_path_case")<cr>',
			desc = "to_path_case",
		},
	},
	opts = {
		default_keymappings_enabled = false,
	},
}
