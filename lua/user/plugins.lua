local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- reload neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- core functionality
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("rcarriga/nvim-notify")

	-- colorschemes
	use({ "bluz71/vim-nightfly-colors", as = "nightfly" })

	-- crates
	use({
		"saecki/crates.nvim",
		tag = "v0.3.0",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup()
		end,
	})

	-- completions
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/nvim-cmp")
	use("saadparwaiz1/cmp_luasnip")
	use({
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	})

	-- snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets") -- todo roll some cpp snippets

    use { "johmsalas/text-case.nvim",
      config = function()
        require('textcase').setup {
            default_keymappings_enabled = false,
        }
      end
    }

	-- lsp
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({
				with_sync = true,
			})
			ts_update()
		end,
	})
	use("p00f/nvim-ts-rainbow")
	use("windwp/nvim-autopairs")

	-- syntax highlighting
	use("peterhoeg/vim-qml")

	-- comments
	use("numToStr/Comment.nvim")

	-- git
	use("lewis6991/gitsigns.nvim")

	-- nvim tree
	use("kyazdani42/nvim-tree.lua")

	-- noice
    -- use nightly for this?
	use({
		"folke/noice.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	})

	-- debugging
	use("mfussenegger/nvim-dap")
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    use({ 'Weissle/persistent-breakpoints.nvim' })

    -- ai
    use({
        "jackMort/ChatGPT.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

	-- automatically set up your configuration after cloning packer.nvim
	-- leave at the end of the list
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
