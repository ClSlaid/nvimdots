local M = {}

-- Argument vectors work with spaces in paths and with cmd.exe/PowerShell as well as POSIX shells.
function M.run(argv, cwd)
	local result = vim.system(argv, { cwd = cwd, text = true }):wait()
	if result.code ~= 0 then
		error(table.concat(argv, " ") .. " failed:\n" .. (result.stderr or result.stdout or ""))
	end
end

function M.telescope_fzf(plugin)
	if vim.fn.executable("cmake") == 1 then
		M.run({ "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release" }, plugin.dir)
		M.run({ "cmake", "--build", "build", "--config", "Release" }, plugin.dir)
		M.run({ "cmake", "--install", "build", "--prefix", "build", "--config", "Release" }, plugin.dir)
	elseif vim.fn.executable("make") == 1 then
		M.run({ "make" }, plugin.dir)
	else
		vim.notify("Native Telescope sorter skipped: install CMake and a C compiler to enable it.", vim.log.levels.WARN)
	end
end

return M
