-- Dependency-free regressions: nvim --headless -u NONE -i NONE -l tests/config.lua
local root = vim.uv.cwd()
vim.opt.rtp:prepend(root)
package.path = package.path .. ";" .. root .. "/lua/modules/configs/?.lua;" .. root .. "/lua/modules/configs/?/init.lua"
local count = 0
local function test(name, fn)
	local ok, err = xpcall(fn, debug.traceback)
	if not ok then
		io.stderr:write(name .. ": " .. err .. "\n")
		vim.cmd("cquit 1")
	end
	count = count + 1
	print("ok: " .. name)
end

local function mock(target, values, fn)
	local previous = {}
	for key, value in pairs(values) do
		previous[key] = target[key]
		target[key] = value
	end
	local ok, err = xpcall(fn, debug.traceback)
	for key in pairs(values) do
		target[key] = previous[key]
	end
	assert(ok, err)
end

local function fresh(name)
	package.loaded[name] = nil
	return require(name)
end

test("Lua syntax and JSON", function()
	for _, file in ipairs(vim.fn.glob(root .. "/lua/**/*.lua", true, true)) do
		assert(loadfile(file))
	end
	vim.json.decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
	vim.json.decode(table.concat(vim.fn.readfile("chatgpt/actions.json"), "\n"))
end)

test("settings and non-recursive dashboard", function()
	local settings = require("core.settings")
	assert(settings.use_chat == false)
	assert(settings.use_ssh == false)
	assert(not vim.islist(settings.pred_optional_params))
	local header = vim.deepcopy(settings.dashboard_image)
	for _ = 1, 3 do
		local chadrc = fresh("chadrc")
		assert(type(chadrc) == "table")
		assert(#chadrc.nvdash.header == #header + 3)
		assert(vim.deep_equal(settings.dashboard_image, header), "dashboard mutated shared settings")
		for _, button in ipairs(chadrc.nvdash.buttons) do
			assert(button.cmd == nil or type(button.cmd) == "string")
		end
	end
end)

for _, platform in ipairs({
	{ name = "Linux", wsl = false },
	{ name = "Darwin", wsl = false },
	{ name = "Windows_NT", wsl = false },
	{ name = "Linux", wsl = true },
}) do
	test("platform setup: " .. platform.name .. (platform.wsl and " (WSL)" or ""), function()
		mock(vim.uv, {
			os_uname = function()
				return { sysname = platform.name }
			end,
			fs_realpath = function()
				return nil
			end,
		}, function()
			mock(vim.fn, {
				has = function(feature)
					return feature == "wsl" and platform.wsl and 1 or 0
				end,
				stdpath = function(kind)
					return "C:/Profile With Spaces/" .. kind
				end,
			}, function()
				local global = fresh("core.global")
				assert(global.is_windows == (platform.name == "Windows_NT"))
				assert(global.is_mac == (platform.name == "Darwin"))
				assert(global.is_wsl == platform.wsl)
				assert(global.vim_path == "C:/Profile With Spaces/config")
				assert(global.modules_dir == global.vim_path .. "/lua/modules")
			end)
		end)

		local dirs, options = {}, {}
		local clipboard = vim.g.clipboard
		vim.g.clipboard = nil
		mock(vim.fn, {
			mkdir = function(dir)
				dirs[#dirs + 1] = dir
			end,
			executable = function(cmd)
				return cmd == "pwsh" and 1 or 0
			end,
		}, function()
			mock(vim.api, {
				nvim_set_option_value = function(k, v)
					options[k] = v
				end,
			}, function()
				mock(vim.cmd, { colorscheme = function() end }, function()
					mock(
						package.loaded,
						{ ["core.options"] = true, ["core.event"] = true, ["core.pack"] = true, keymap = true },
						function()
							fresh("core")
						end
					)
				end)
			end)
		end)
		for _, name in ipairs({ "backup", "session", "swap", "tags", "undo" }) do
			assert(vim.tbl_contains(dirs, require("core.global").cache_dir .. "/" .. name), "missing cache: " .. name)
		end
		if platform.name == "Windows_NT" then
			assert(options.shell == "pwsh")
		end
		if platform.name == "Darwin" then
			assert(vim.g.clipboard.copy["+"] == "pbcopy")
		end
		if platform.wsl then
			assert(vim.g.clipboard == nil, "must not force missing win32yank.exe")
		end
		vim.g.clipboard = clipboard
	end)
end
fresh("core.global")

test("plugin discovery ignores wildignore and paths with punctuation", function()
	local glob, original_system = vim.fn.glob, vim.system
	local captured, clone
	mock(vim.fn, {
		glob = function(pattern, nosuf, list)
			assert(nosuf == true and list == true)
			return glob(pattern, nosuf, list)
		end,
	}, function()
		mock(package.loaded, { lazy = {
			setup = function(specs)
				captured = specs
			end,
		} }, function()
			mock(vim.uv, {
				fs_stat = function()
					return nil
				end,
			}, function()
				vim.system = function(argv)
					clone = argv
					return {
						wait = function()
							return { code = 0 }
						end,
					}
				end
				local ok, err = pcall(fresh, "core.pack")
				vim.system = original_system
				assert(ok, err)
			end)
		end)
	end)
	assert(clone[1] == "git" and clone[2] == "clone" and #clone == 6)
	assert(#captured > 50)
	local names = {}
	for _, plugin in ipairs(captured) do
		assert(not names[plugin[1]], "duplicate plugin: " .. plugin[1])
		names[plugin[1]] = true
	end
	assert(names["ayamir/nvchad-ui"] and names["saghen/blink.cmp"])
	assert(not names["williamboman/mason-lspconfig.nvim"])
end)

test("DAP launch arguments are deferred and Windows is not detached", function()
	for _, windows in ipairs({ false, true }) do
		local dap = { adapters = {}, configurations = {} }
		mock(package.loaded, { dap = dap, ["core.global"] = { is_windows = windows } }, function()
			require("tool.dap.clients.codelldb")()
			assert(dap.adapters.codelldb.detached == not windows)
			assert(type(dap.configurations.c[1].program) == "function")
			require("tool.dap.clients.lldb")()
			assert(dap.configurations.rust ~= dap.configurations.c)
			assert(dap.configurations.cpp ~= dap.configurations.c)
		end)
	end
end)

test("build commands do not interpolate shell strings", function()
	local commands = {}
	mock(vim, {
		system = function(argv, opts)
			assert(type(argv) == "table" and opts.cwd == "C:/Profile With Spaces/plugin")
			commands[#commands + 1] = argv
			return {
				wait = function()
					return { code = 0 }
				end,
			}
		end,
	}, function()
		mock(vim.fn, {
			executable = function(cmd)
				return cmd == "cmake" and 1 or 0
			end,
		}, function()
			require("modules.utils.build").telescope_fzf({ dir = "C:/Profile With Spaces/plugin" })
		end)
	end)
	assert(#commands == 3 and commands[3][2] == "--install")
end)

test("missing Treesitter parser never calls start", function()
	mock(package.loaded, { ["keymap.completion"] = { lsp = function() end } }, function()
		fresh("core.event")
	end)
	local starts = 0
	mock(vim.treesitter, {
		start = function()
			starts = starts + 1
		end,
	}, function()
		mock(vim.treesitter.language, {
			get_lang = function()
				return "not_installed"
			end,
			add = function()
				return false, "no parser"
			end,
		}, function()
			vim.api.nvim_exec_autocmds("FileType", { pattern = "unavailable_language" })
		end)
	end)
	assert(starts == 0)
end)

test("neoconf notifications use window-local spell", function()
	local util, callback = {}, nil
	mock(package.loaded, {
		["neoconf.util"] = util,
		["modules.utils"] = { load_plugin = function() end },
	}, function()
		require("completion.neoconf").setup()
		mock(vim, {
			notify = function(_, _, opts)
				callback = opts.on_open
			end,
		}, function()
			util.notify("test", vim.log.levels.WARN)
		end)
	end)
	local win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
		relative = "editor",
		row = 0,
		col = 0,
		width = 20,
		height = 5,
	})
	callback(win)
	assert(vim.wo[win].spell == false)
	vim.api.nvim_win_close(win, true)
end)

test("hover URLs use the platform opener without a shell", function()
	local hover, opened, options = {}, nil, nil
	mock(package.loaded, {
		["lspsaga.hover"] = hover,
		["modules.utils"] = { load_plugin = function() end },
	}, function()
		require("completion.lspsaga")()
		mock(vim.treesitter, {
			get_node = function()
				return {
					type = function()
						return "inline"
					end,
				}
			end,
			get_node_text = function()
				return "[test](https://example.org/?a=1&b=2)"
			end,
		}, function()
			mock(vim.ui, {
				open = function(url, opts)
					opened, options = url, opts
				end,
			}, function()
				hover:open_link() -- Missing hover buffer must be harmless.
				hover.bufnr = vim.api.nvim_get_current_buf()
				hover:open_link()
				assert(opened == "https://example.org/?a=1&b=2" and options == nil)
				mock(require("core.settings"), { external_browser = "C:/Program Files/Browser/browser.exe" }, function()
					hover:open_link()
					assert(options.cmd[1] == "C:/Program Files/Browser/browser.exe")
				end)
			end)
		end)
	end)
end)

print(string.format("PASS: %d configuration regressions", count))
vim.cmd("qa!")
