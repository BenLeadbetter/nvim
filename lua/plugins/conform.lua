return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format",
		},
	},
	opts = {
		log_level = vim.log.levels.DEBUG,
		formatters_by_ft = {
			cmake = { "cmake_format" },
			cpp = { "clang-format" },
			rust = { "rustfmt" },
			qml = { "qmlformat" },
		},
		formatters = {
			qmlformat = {
				meta = {
					url = "https://doc.qt.io/qt-6//qtqml-tooling-qmlformat.html",
					description = "qmlformat is a tool that automatically formats QML files in accordance with the QML Coding Conventions.",
				},
				command = "qmlformat",
				args = { "$FILENAME" },
			},
		},
	},
}
