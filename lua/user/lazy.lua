local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	-- bootstrap lazy.nvim
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	vim.notify("Couldn't locate package manager", vim.log.levels.WARN)
	return
end

return lazy.setup({
    spec = {
    { import = "plugin" },
  },
  defaults = {
    lazy = true,
    version = "*",
  },
  install = { colorscheme = { "nightfly" } },
  checker = { enabled = true },
})
	-- -- core functionality
	-- use("nvim-lua/popup.nvim")
	-- use("rcarriga/nvim-notify")
	--
	-- -- crates
	-- use({
	-- 	"saecki/crates.nvim",
	-- 	tag = "v0.3.0",
	-- 	requires = { "nvim-lua/plenary.nvim" },
	-- 	config = function()
	-- 		require("crates").setup()
	-- 	end,
	-- })
	--
	-- -- completions
	-- use("hrsh7th/cmp-buffer")
	-- use("hrsh7th/cmp-cmdline")
	-- use("hrsh7th/cmp-nvim-lsp")
	-- use("hrsh7th/cmp-path")
	-- use("hrsh7th/nvim-cmp")
	-- use("saadparwaiz1/cmp_luasnip")
	-- use({
	-- 	"tzachar/cmp-tabnine",
	-- 	run = "./install.sh",
	-- 	requires = "hrsh7th/nvim-cmp",
	-- })
	--
	-- -- snippets
	-- use("L3MON4D3/LuaSnip")
	-- use("rafamadriz/friendly-snippets") -- todo roll some cpp snippets
	--
	-- use({
	-- 	"johmsalas/text-case.nvim",
	-- 	config = function()
	-- 		require("textcase").setup({
	-- 			default_keymappings_enabled = false,
	-- 		})
	-- 	end,
	-- })
	--
	-- -- lsp
	-- use("neovim/nvim-lspconfig")
	-- use("williamboman/mason.nvim")
	-- use("williamboman/mason-lspconfig.nvim")
	-- use("jose-elias-alvarez/null-ls.nvim")
	--
	-- -- treesitter
	-- use({
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	run = function()
	-- 		local ts_update = require("nvim-treesitter.install").update({
	-- 			with_sync = true,
	-- 		})
	-- 		ts_update()
	-- 	end,
	-- })
	-- use("p00f/nvim-ts-rainbow")
	-- use("windwp/nvim-autopairs")
	--
	-- -- syntax highlighting
	-- use("peterhoeg/vim-qml")
	--
	--
	-- -- git
	-- use("lewis6991/gitsigns.nvim")
	--
	-- -- noice
	-- -- use nightly for this?
	-- use({
	-- 	"folke/noice.nvim",
	-- 	requires = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 	},
	-- })
	--
	-- -- debugging
	-- use("mfussenegger/nvim-dap")
	-- use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	-- use({ "Weissle/persistent-breakpoints.nvim" })
	--
	-- -- ai
	-- use({
	-- 	"jackMort/ChatGPT.nvim",
	-- 	requires = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- })
-- end)
