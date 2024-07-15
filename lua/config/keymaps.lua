local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<S-Up>", ":resize +2<CR>", opts)
keymap("n", "<S-Down>", ":resize -2<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- buffer navigation
keymap("n", "]a", ":next<cr>", opts)
keymap("n", "[a", ":prev<cr>", opts)
keymap("n", "]A", ":first<cr>", opts)
keymap("n", "[A", ":last<cr>", opts)
keymap("n", "]b", ":bnext<cr>", opts)
keymap("n", "[b", ":bprev<cr>", opts)
keymap("n", "]B", ":blast<cr>", opts)
keymap("n", "[B", ":bfirst<cr>", opts)
keymap("n", "<leader>qab", ":bufdo bw<cr>", opts)
keymap("n", "<leader>qa!", ":bufdo bw!<cr>", opts)
