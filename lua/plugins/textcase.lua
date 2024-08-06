return {
	"johmsalas/text-case.nvim",
	keys = {
		{
			"<leader>Tu",
			'<cmd>lua require("textcase").current_word("to_upper_case")<cr>',
			desc = "to_upper_case",
		},
		{
			"<leader>Tu",
			'<cmd>lua require("textcase").current_word("to_upper_case")<cr>',
			desc = "to_upper_case",
		},
		{
			"<leader>Tl",
			'<cmd>lua require("textcase").current_word("to_lower_case")<cr>',
			desc = "to_lower_case",
		},
		{
			"<leader>Ts",
			'<cmd>lua require("textcase").current_word("to_snake_case")<cr>',
			desc = "to_snake_case",
		},
		{
			"<leader>Td",
			'<cmd>lua require("textcase").current_word("to_dash_case")<cr>',
			desc = "to_dash_case",
		},
		{
			"<leader>Tn",
			'<cmd>lua require("textcase").current_word("to_constant_case")<cr>',
			desc = "to_constant_case",
		},
		{
			"<leader>Td",
			'<cmd>lua require("textcase").current_word("to_dot_case")<cr>',
			desc = "to_dot_case",
		},
		{
			"<leader>Ta",
			'<cmd>lua require("textcase").current_word("to_phrase_case")<cr>',
			desc = "to_phrase_case",
		},
		{
			"<leader>Tc",
			'<cmd>lua require("textcase").current_word("to_camel_case")<cr>',
			desc = "to_camel_case",
		},
		{
			"<leader>Tp",
			'<cmd>lua require("textcase").current_word("to_pascal_case")<cr>',
			desc = "to_pascal_case",
		},
		{
			"<leader>Tt",
			'<cmd>lua require("textcase").current_word("to_title_case")<cr>',
			desc = "to_title_case",
		},
		{
			"<leader>Tf",
			'<cmd>lua require("textcase").current_word("to_path_case")<cr>',
			desc = "to_path_case",
		},
	},
	opts = {
		default_keymappings_enabled = false,
	},
}
