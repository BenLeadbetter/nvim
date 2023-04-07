local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
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

-- side explorer
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- buffers
keymap("n", "<S-h>", ":bnext<cr>", opts)
keymap("n", "<S-l>", ":bprev<cr>", opts)

keymap("n", "<leader>f", "<cmd>Telescope find_files theme=dropdown<cr>", opts)
keymap("n", "<leader>rg", "<cmd>Telescope live_grep<cr>", opts)
