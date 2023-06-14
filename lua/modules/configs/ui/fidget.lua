return function()
	require("fidget").setup({
		window = { blend = 10 },
		sources = {
			["null-ls"] = { ignore = true },
		},
		fmt = {
			max_messages = 3, -- The maximum number of messages stacked at any give time
		},
	})
end
