return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.servers = opts.servers or {}
		opts.servers.qmlls = opts.servers.qmlls or {}
		opts.servers.qmlls.cmd = opts.servers.qmlls.cmd or {}
		opts.servers.qmlls.imports = opts.servers.qmlls.imports or {}

		table.insert(opts.servers.qmlls.cmd, "qmlls")
        table.insert(opts.servers.qmlls.cmd, "--no-cmake-calls")

		local has_cmake, cmake = pcall(require, "cmake-tools")
		if has_cmake then
			table.insert(opts.servers.qmlls.cmd, "--build-dir")
			table.insert(opts.servers.qmlls.cmd, cmake.get_build_directory():absolute())
            -- todo: 
            -- this arg seems necessary for the server to work, but 
            -- we shouldn't hard code the value
			-- table.insert(opts.servers.qmlls.cmd, "--build-dir")
			-- table.insert(opts.servers.qmlls.cmd, "/Users/ben.leadbetter/code/NIBuild/3rdparty/Qt/Qt-6.7.1-R1-macx-clang-static/qml")
		end

		opts.servers.qmlls.on_attach = function()
            local qmlls_opts = opts.servers.qmlls
			for _, import in ipairs(qmlls_opts.imports) do
				table.insert(qmlls_opts.cmd, "-I")
				table.insert(qmlls_opts.cmd, import)
			end
		end

		return opts
	end,
	dependencies = {
		"Civitasv/cmake-tools.nvim",
		optional = true,
	},
}
