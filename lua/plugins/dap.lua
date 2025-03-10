return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>dL",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log Point",
			},
		},
	},
}
