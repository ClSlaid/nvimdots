return function()
	require("lean").setup({
		abbreviations = { builtin = true },
		mappings = false,
	})
end
