local sessions_dir = vim.uv.cwd() .. "/.nvim/sessions/"

local function sessions_dir_exists()
	local stat = vim.uv.fs_stat(sessions_dir)
	return stat and stat.type == "directory"
end

local function nvim_opened_in_file_mode()
	if #vim.v.argv > 1 then
		for i = 2, #vim.v.argv do
			local arg = vim.v.argv[i]
			if not string.match(arg, "^-") then
				require("user.log").info("vim opened in file mode")
				return true
			end
		end
	end
	return false
end

local dir_exists = sessions_dir_exists()
local file_mode = nvim_opened_in_file_mode()

return {
	"folke/persistence.nvim",
	lazy = false,
	enabled = not file_mode,
	config = function()
		local persistence = require("persistence")
		persistence.setup({
			dir = sessions_dir,
			need = 0,
		})

		if dir_exists and not file_mode then
			persistence.load({ last = true })
		end
	end,
}
