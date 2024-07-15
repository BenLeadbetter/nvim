local colorscheme = "nightfly"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if colorscheme == "nightfly" then
	-- first bracket appears pink rather than red
	vim.cmd(":hi rainbowcol1 guifg=#FF06BC")
end

if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
