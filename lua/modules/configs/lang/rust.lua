return function()
	vim.g.rustaceanvim = {
		server = {
			-- standalone file support
			-- setting it to false may improve startup time
			standalone = true,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						features = "all",
					},
					lru = {
						capacity = 4096,
					},
					procMacro = {
						enable = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		}, -- DAP configuration
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	}

	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
