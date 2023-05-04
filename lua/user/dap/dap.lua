local has_dap, dap = pcall(require, "dap")
if not has_dap then
	return
end

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "/Users/ben.leadbetter/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.cpp = {
	{
		name = "launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
	{
		name = "wait",
		type = "codelldb",
		request = "attach",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		waitFor = true, -- only supported on macos
	},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "red", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "", linehl = "red", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "red", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "red", linehl = "", numhl = "" })
