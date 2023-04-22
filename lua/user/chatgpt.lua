local has_chatgpt, chatgpt = pcall(require, "chatgpt")
if not has_chatgpt then
	return
end

chatgpt.setup({
	chat = {
		keymaps = {
			close = { "<C-q>" },
			yank_last = "<C-y>",
			yank_last_code = "<C-k>",
			scroll_up = "<C-u>",
			scroll_down = "<C-d>",
			toggle_settings = "<C-o>",
			new_session = "<C-n>",
			cycle_windows = "<Tab>",
			select_session = "<Space>",
			rename_session = "r",
			delete_session = "d",
		},
	},
	openai_params = {
		model = "gpt-3.5-turbo", -- waiting on gpt-4 api access
		frequency_penalty = 0,
		presence_penalty = 0,
		max_tokens = 300,
		temperature = 0,
		top_p = 1,
		n = 1,
	},
    predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
})
