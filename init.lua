if vim.g.vscode then
	return
end

require("user.options")
require("user.colorscheme")
require("user.keymaps")
require("user.plugins")
require("user.cmp")
require("user.lsp")
require("user.spelling")
require("user.tabnine")
require("user.telescope")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.nvimtree")
