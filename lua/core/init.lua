local settings = require("core.settings")
local global = require("core.global")

-- Create cache dir and data dirs
local createdir = function()
	local data_dirs = {
		global.cache_dir .. "/backup",
		global.cache_dir .. "/session",
		global.cache_dir .. "/swap",
		global.cache_dir .. "/tags",
		global.cache_dir .. "/undo",
	}
	for _, dir in ipairs(data_dirs) do
		vim.fn.mkdir(dir, "p")
	end
end

local leader_map = function()
	vim.g.mapleader = " "
	-- NOTE:
	--  > Uncomment the following if you're using a <leader> other than <Space>, and you wish
	--  > to disable advancing one character by pressing <Space> in normal/visual mode.
	-- vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
	-- vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

local gui_config = function()
	if next(settings.gui_config) then
		vim.api.nvim_set_option_value(
			"guifont",
			settings.gui_config.font_name .. ":h" .. settings.gui_config.font_size,
			{}
		)
	end
end

local neovide_config = function()
	for name, config in pairs(settings.neovide_config) do
		vim.g["neovide_" .. name] = config
	end
end

local clipboard_config = function()
	if global.is_mac then
		vim.g.clipboard = {
			name = "macOS-clipboard",
			copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
			paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
			cache_enabled = 0,
		}
	elseif global.is_wsl and vim.fn.executable("win32yank.exe") == 1 then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	end
end

local shell_config = function()
	if global.is_windows then
		if not (vim.fn.executable("pwsh") == 1 or vim.fn.executable("powershell") == 1) then
			vim.notify(
				[[
Failed to setup terminal config

PowerShell is either not installed, missing from PATH, or not executable;
The existing shell will be used instead for `:!` and terminal buffers.

You're recommended to install PowerShell for better experience.]],
				vim.log.levels.WARN,
				{ title = "[core] Runtime Warning" }
			)
			return
		end

		local basecmd = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned"
		local ctrlcmd = "-Command [console]::InputEncoding = [console]::OutputEncoding = [System.Text.Encoding]::UTF8"
		local set_opts = vim.api.nvim_set_option_value
		set_opts("shell", vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", {})
		set_opts("shellcmdflag", string.format("%s %s;", basecmd, ctrlcmd), {})
		set_opts("shellredir", "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode", {})
		set_opts("shellpipe", "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode", {})
		set_opts("shellquote", "", {})
		set_opts("shellxquote", "", {})
	end
end

local load_core = function()
	createdir()
	leader_map()

	gui_config()
	neovide_config()
	clipboard_config()
	shell_config()

	-- Base46 reads this during plugin initialization and its build hook.
	vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
	vim.api.nvim_set_option_value("background", settings.background, {})

	-- Finish initializing the built-in LSP before plugin installers can yield
	-- and dispatch callbacks that try to require it recursively.
	require("vim.lsp")
	require("core.options")
	require("core.event")
	require("core.pack")
	require("keymap")

	vim.cmd.colorscheme("nvchad")
end

load_core()
