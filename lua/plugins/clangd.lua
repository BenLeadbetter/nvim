return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		local cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=never",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		}

		-- CMake build dirs often sit outside the source root (e.g. ../build), where
		-- clangd's upward search for compile_commands.json never reaches.
		local build_dir = require("user.local-config").build_dir()
		if build_dir then
			table.insert(cmd, "--compile-commands-dir=" .. build_dir)
		end

		-- Assigned rather than merged: vim.tbl_deep_extend would splice this list
		-- index-by-index against the one LazyVim's clangd extra already set.
		opts.servers = opts.servers or {}
		opts.servers.clangd = opts.servers.clangd or {}
		opts.servers.clangd.cmd = cmd

		return opts
	end,
}
