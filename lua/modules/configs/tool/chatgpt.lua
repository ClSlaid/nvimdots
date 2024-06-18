return function()
	local home = vim.fn.expand("$HOME")
	require("modules.utils").load_plugin("chatgpt", {
		api_host_cmd = "echo https://api.deepseek.com",
		api_key_cmd = "cat " .. home .. "/.config/chatgpt/key.txt",
		openai_params = {
			model = "deepseek-coder",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 1000,
			temperature = 1.0,
			top_p = 1,
			n = 1,
		},
		openai_edit_params = {
			model = "deepseek-coder",
			frequency_penalty = 0,
			presence_penalty = 0,
			temperature = 1.0,
			top_p = 1,
			n = 1,
		},
		actions_paths = {
			vim.fn.stdpath("config") .. "/chatgpt/actions.lua",
		},
	})
end
