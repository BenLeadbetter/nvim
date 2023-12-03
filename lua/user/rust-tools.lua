local status_ok, rt = pcall(require, "rust-tools")
if not status_ok then
	return
end

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
