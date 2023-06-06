return function()
	require("fidget").setup({
		window = { blend = 10 },
		sources = {
			["null-ls"] = { ignore = true },
		},
	})
end
