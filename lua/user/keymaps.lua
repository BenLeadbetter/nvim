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

-- telescope
keymap("n", "<leader>f", "<cmd>Telescope find_files no_ignore=true theme=dropdown<cr>", opts)
keymap("n", "<leader>rg", "<cmd>Telescope live_grep<cr>", opts)

-- buffers
keymap("n", "<leader>qab", ":bufdo bw<cr>", opts)
keymap("n", "<leader>qa!", ":bufdo bw!<cr>", opts)
keymap("n", "<leader>wa", ":bufdo w<cr>", opts)

-- formatting
local range_format = function()
	local start_row, _ = vim.api.nvim_buf_get_mark(0, "<")
	local end_row, _ = vim.api.nvim_buf_get_mark(0, ">")
	vim.lsp.buf.format({
		range = {
			["start"] = { start_row, 0 },
			["end"] = { end_row, 0 },
		},
		async = true,
		normal = true,
	})
end
vim.keymap.set("v", "<leader>F", range_format)
keymap("n", "<leader>F", ":lua vim.lsp.buf.format()<cr>", opts)

local function with_dap(f)
    return function()
        local has_dap, dap = pcall(require, "dap")
        if has_dap then
            f(dap)
        end
    end
end

-- debugging
vim.keymap.set(
	"n",
	"<F5>",
	with_dap(function(dap)
		dap.continue()
	end)
)
vim.keymap.set(
	"n",
	"<F10>",
	with_dap(function(dap)
		dap.step_over()
	end)
)
vim.keymap.set(
	"n",
	"<F11>",
	with_dap(function(dap)
		dap.step_into()
	end)
)
vim.keymap.set(
	"n",
	"<F12>",
	with_dap(function(dap)
		dap.step_out()
	end)
)
vim.keymap.set(
	"n",
	"<Leader>db",
	with_dap(function(dap)
		dap.toggle_breakpoint()
	end)
)
vim.keymap.set(
	"n",
	"<Leader>dB",
	with_dap(function(dap)
		dap.set_breakpoint()
	end)
)
vim.keymap.set(
	"n",
	"<Leader>dlp",
	with_dap(function(dap)
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end)
)
vim.keymap.set(
	"n",
	"<Leader>dr",
	with_dap(function(dap)
		dap.repl.open()
	end)
)
vim.keymap.set(
	"n",
	"<Leader>dl",
	with_dap(function(dap)
		dap.run_last()
	end)
)
vim.keymap.set(
	{ "n", "v" },
	"<Leader>dh",
	with_dap(function(dap)
		dap.ui.widgets.hover()
	end)
)
vim.keymap.set(
	{ "n", "v" },
	"<Leader>dp",
	with_dap(function(dap)
		dap.ui.widgets.preview()
	end)
)
vim.keymap.set("n", "<Leader>dg", function()
	local has_dapui, dapui = pcall(require, "dapui")
	if has_dapui then
		dapui.toggle()
	end
end)

-- ai
if pcall(require, "chatgpt") then
    vim.keymap.set("v", "<leader>ai", function() require("chatgpt").edit_with_instructions() end)
    keymap("n", "<leader>ai", ":ChatGPT<cr>", opts)
end
