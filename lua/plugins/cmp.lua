return {
	"hrsh7th/nvim-cmp",
	opts = {
		mapping = {
			["<C-k>"] = require("cmp").mapping.select_prev_item(),
			["<C-j>"] = require("cmp").mapping.select_next_item(),
			["<C-u>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(-1), { "i", "c" }),
			["<C-d>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(1), { "i", "c" }),
			["<Tab>"] = require("cmp").mapping(function(fallback)
				local cmp = require("cmp")
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = require("cmp").mapping(function(fallback)
				local cmp = require("cmp")
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),
		},
	},
}
