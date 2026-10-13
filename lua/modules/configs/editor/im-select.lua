return function()
	local opts = {}
	if require("core.global").is_mac and vim.fn.executable("macism") == 0 then
		opts.default_command = "im-select"
	end
	require("im_select").setup(opts)
end
