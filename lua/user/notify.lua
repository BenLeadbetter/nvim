local has_notify, notify = pcall(require, "notify")
if not has_notify then
	return
end

notify.setup({
    max_width = 80,
    render = "compact",
    stages = "static",
    top_down = false,
})

vim.notify = notify
