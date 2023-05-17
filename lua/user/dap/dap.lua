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

local init_commands = {
    -- todo: fix these formatters
    -- "command script import ~/code/lldb-qt/QtFormatters.py",
    -- "command source ~/code/lldb-qt/QtFormatters.lldb",

    -- qt source map
    -- run the following to find the build path prefix
    -- > strings NIBuild/3rdparty/Qt/Qt-xxx/lib/libQt6Core.a | grep -E "(jenkins|bamboo)"
    "settings append target.source-map /Volumes/build/bamboo-build/THIRDP-QT98-BAMN/sources /Users/ben.leadbetter/code/NIBuild/qt",
}

local pre_run_commands = {
    -- custom scripting
    -- "command script add -f ben_custom.disable_cpp_break_on_except disable_cpp_break_on_except",
    -- "command disable_cpp_break_on_except",

    -- unset break on throw / catch
    -- todo: who is setting this in the first place?
    "breakpoint delete cpp_exception",
}

dap.configurations.cpp = {
	{
		name = "launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return require("user.dap.debug_target").debug_target()
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
        init_commands = init_commands,
        preRunCommands = pre_run_commands,
	},
	{
		name = "wait",
		type = "codelldb",
		request = "attach",
		program = function()
			return require("user.dap.debug_target").debug_target()
		end,
		waitFor = true, -- only supported on macos
        initCommands = init_commands,
        preRunCommands = pre_run_commands,
	},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "red", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "", linehl = "red", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "red", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "red", linehl = "", numhl = "" })
