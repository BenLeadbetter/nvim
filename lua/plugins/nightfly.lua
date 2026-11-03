return {
	"bluz71/vim-nightfly-colors",
	as = "nightfly",
	lazy = false,
	init = function()
		-- NOTE: Re-applied on every ColorScheme event since `:colorscheme` clears all highlights first.
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "nightfly",
			callback = function()
				local palette = require("nightfly").palette
				-- NOTE: Doc comments use a brighter shade than ordinary comments (`grey_blue`).
				vim.api.nvim_set_hl(0, "@comment.documentation", { fg = palette.cadet_blue, italic = true })
				-- NOTE: LSP semantic tokens (e.g. rust-analyzer) outrank Tree-sitter, so the doc comment
				-- token must be styled too. Uses the type+modifier group so code inside doctests, which
				-- also carries the `documentation` modifier, keeps its normal highlighting.
				vim.api.nvim_set_hl(0, "@lsp.typemod.comment.documentation", { link = "@comment.documentation" })
			end,
		})
	end,
}
