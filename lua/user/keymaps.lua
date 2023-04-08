local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Resize with arrows
keymap("n", "<S-Up>", ":resize +2<CR>", opts)
keymap("n", "<S-Down>", ":resize -2<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- nvim tree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- buffers
keymap("n", "<S-h>", ":bnext<cr>", opts)
keymap("n", "<S-l>", ":bprev<cr>", opts)

keymap("n", "<leader>f", "<cmd>Telescope find_files theme=dropdown<cr>", opts)
keymap("n", "<leader>rg", "<cmd>Telescope live_grep<cr>", opts)

-- formatting
RangeFormat = function()
	local start_row, _ = vim.api.nvim_buf_get_mark(0, "<")
	local end_row, _ = vim.api.nvim_buf_get_mark(0, ">")
	vim.lsp.buf.format({
		range = {
			["start"] = { start_row, 0 },
			["end"] = { end_row, 0 },
		},
		async = true,
	})
end
vim.keymap.set("v", "<leader>f", RangeFormat)
keymap("n", "<leader>F", ":lua vim.lsp.buf.format()<CR>", opts)
