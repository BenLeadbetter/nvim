return {
	"Civitasv/cmake-tools.nvim",
	enabled = false,
	opts = function(_, opts)
		opts.cmake_regenerate_on_save = false

		local build_dir = require("user.local-config").build_dir()
		if build_dir then
			opts.cmake_build_directory = build_dir
		end

		return opts
	end,
}
