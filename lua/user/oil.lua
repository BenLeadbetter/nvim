local status_ok, oil = pcall(require, "oil")
if not status_ok then
	return
end
oil.setup({
	columns = {
		"icon",
	},
	delete_to_trash = true,
	skip_confirm_for_simple_edits = false,
	prompt_save_on_select_new_entry = false,
	cleanup_delay_ms = 2000,
	use_default_keymaps = false,
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-t>"] = {
			"actions.select",
			opts = { tab = true },
			desc = "Open the entry in a new tab",
		},
		["<C-p>"] = "actions.preview",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	view_options = {
		natural_order = true,
	},
})
