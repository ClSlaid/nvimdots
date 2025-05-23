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
				},
			},
		}, -- DAP configuration
		dap = { adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path) },
		-- dap = {
		-- 	adapter = {
		-- 		type = "server",
		-- 		port = "${port}",
		-- 		executable = {
		-- 			command = vim.fn.exepath("codelldb"), -- Find codelldb on $PATH
		-- 			args = { "--port", "${port}" },
		-- 			detached = is_windows and false or true,
		-- 		},
		-- 		name = "rustaceanvim-codelldb",
		-- 		preRunCommands = {
		-- 			"script import subprocess;rustc=lambda *a: subprocess.run(['rustc',*a],stdout=subprocess.PIPE,check=True,text=True).stdout;sysroot=rustc('--print','sysroot').strip();gitsha=rustc('-vV').partition('commit-hash:')[-1].partition('\\n')[0].strip();lldb.debugger.HandleCommand(f'settings set target.source-map /rustc/{gitsha} \"{sysroot}/lib/rustlib/src/rust\"')",
		-- 		},
		-- 	},
		-- },
	}

	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
