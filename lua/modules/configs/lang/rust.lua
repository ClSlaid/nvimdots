return function()
	local is_windows = require("core.global").is_windows

	local cfg = require("rustaceanvim.config")
	local this_os = vim.loop.os_uname().sysname:lower()

	local base_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
	local lib_suffix = ""
	local exe_suffix = ""
	if this_os == "windows" then
		lib_suffix = ".dll"
		exe_suffix = ".exe"
	elseif this_os == "darwin" then
		lib_suffix = ".dylib"
	else
		lib_suffix = ".so"
	end

	local liblldb_path = base_path .. "lldb/lib/liblldb" .. lib_suffix

	local codelldb_path = base_path .. "adapter/codelldb" .. exe_suffix

	vim.g.rustaceanvim = {
		-- Disable automatic DAP configuration to avoid conflicts with previous user configs
		dap = {
			adapter = false,
			configuration = false,
			autoload_configurations = false,
		},
		tools = {
			executor = require("rustaceanvim.executors").toggleterm,
			reload_workspace_from_cargo_toml = true,
		},
		server = { standalone = true },
	}

	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
