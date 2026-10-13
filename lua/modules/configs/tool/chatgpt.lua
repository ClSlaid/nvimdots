return function()
	-- ChatGPT.nvim reads OPENAI_API_HOST and OPENAI_API_KEY directly on every OS.
	-- For DeepSeek, set OPENAI_API_HOST=https://api.deepseek.com before starting Neovim.
	require("modules.utils").load_plugin("chatgpt", {
		openai_params = {
			model = "deepseek-chat",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 1000,
			temperature = 1.0,
			top_p = 1,
			n = 1,
		},
		openai_edit_params = {
			model = "deepseek-chat",
			frequency_penalty = 0,
			presence_penalty = 0,
			temperature = 1.0,
			top_p = 1,
			n = 1,
		},
		actions_paths = {
			vim.fn.stdpath("config") .. "/chatgpt/actions.json",
		},
	})
end
