return {
	"nvim-mini/mini.pairs",
	opts = function(_, opts)
		local midi_pairs = require("mini.pairs")

		-- Remove default rule for single quote in Rust
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "rust",
			callback = function()
				midi_pairs.unmap("i", "'", "'")
			end,
		})

		return opts
	end,
}
