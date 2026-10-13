-- Run after normal startup, with plugins restored: nvim --headless -i NONE -c "luafile tests/smoke.lua"
-- Filetype checks may start installed language servers; prefer isolated data for reproducibility.
local failures = {}
local function check(name, fn)
	vim.v.errmsg = ""
	local ok, err = pcall(fn)
	-- Builtin ftplugin undo uses `silent! unmap` during lazy FileType replay;
	-- E31 updates v:errmsg even though no error is displayed to the user.
	local message = vim.v.errmsg
	if not ok or (message ~= "" and not message:match("^E31:")) then
		failures[#failures + 1] = name .. ": " .. tostring(err or message)
	end
end

vim.wait(500)
check("dashboard", function()
	vim.cmd.Nvdash()
	vim.cmd.Nvdash()
end)
check("common lazy events", function()
	for _, event in ipairs({ "CursorHold", "CursorMoved", "InsertEnter", "InsertLeave", "CursorHoldI" }) do
		vim.api.nvim_exec_autocmds(event, {})
	end
	vim.wait(500)
end)
check("editing", function()
	vim.cmd.enew()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world", "another line" })
	vim.cmd.normal({ "gg0w", bang = true })
	vim.cmd.normal({ "iTest ", bang = true })
	vim.cmd.normal({ "u", bang = true })
end)
check("filetype events and syntax buffers", function()
	for _, ft in ipairs({ "lua", "c", "cpp", "markdown", "sh", "python" }) do
		vim.cmd.enew({ bang = true })
		-- Servers such as Ruff require a real file URI, not an unnamed buffer.
		vim.api.nvim_buf_set_name(0, vim.fn.tempname() .. "." .. ft)
		vim.bo.filetype = ft
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "-- smoke test" })
		vim.api.nvim_exec_autocmds("CursorMoved", {})
		vim.api.nvim_exec_autocmds("CursorHold", {})
		vim.wait(100)
	end
	vim.cmd.enew({ bang = true })
end)
check("empty buffer shortcut", function()
	for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
		if map.lhs == "<M-9>" and type(map.callback) == "function" then
			map.callback()
		end
	end
end)
check("Telescope", function()
	require("telescope.builtin").buffers()
	vim.wait(100)
	require("telescope.actions").close(vim.api.nvim_get_current_buf())
end)
check("search collections", function()
	vim.cmd.TelescopeCollections()
	vim.wait(100)
	require("telescope.actions").close(vim.api.nvim_get_current_buf())
end)
check("no obsolete Python type checker duplication", function()
	local deps = require("core.settings").lsp_deps
	if vim.tbl_contains(deps, "pyrefly") and not vim.tbl_contains(deps, "zuban") then
		assert(not vim.lsp.is_enabled("zuban"))
	end
end)
check("DAP configuration", function()
	local dap = require("dap")
	assert(type(dap.adapters) == "table")
end)
check("terminal", function()
	require("nvchad.term").toggle({ pos = "float", id = "SmokeTest" })
	vim.wait(100)
	assert(vim.bo.buftype == "terminal")
	local job = vim.b.terminal_job_id
	require("nvchad.term").toggle({ pos = "float", id = "SmokeTest" })
	vim.fn.jobstop(job)
end)
vim.wait(500)
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
	for _, item in ipairs(notify.history()) do
		if item.level == "ERROR" or item.level == vim.log.levels.ERROR then
			failures[#failures + 1] = table.concat(item.message, "\n")
		end
	end
end
if #failures > 0 then
	io.stderr:write(table.concat(failures, "\n") .. "\n")
	vim.cmd("cquit 1")
else
	print("smoke: PASS")
	vim.cmd("qa!")
end
