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
    require("user.log").warn("Couldn't locate package manager")
	return
end

return lazy.setup({
	spec = {
		{ import = "user.plugin" },
	},
	defaults = {
		lazy = true,
		version = "*",
	},
	install = { colorscheme = { "nightfly" } },
	checker = { enabled = true },
})
