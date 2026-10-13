local global = {}
local os_name = vim.uv.os_uname().sysname
local realpath = vim.uv.fs_realpath

function global:load_variables()
	self.is_mac = os_name == "Darwin"
	self.is_linux = os_name == "Linux"
	self.is_windows = os_name == "Windows_NT"
	self.is_wsl = vim.fn.has("wsl") == 1
	self.vim_path = vim.fs.normalize(realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config"))
	self.cache_dir = vim.fn.stdpath("cache")
	self.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))
	self.modules_dir = self.vim_path .. "/lua/modules"
	self.home = (self.is_windows and vim.env.USERPROFILE or vim.env.HOME) or vim.uv.os_homedir()
end

global:load_variables()

return global
