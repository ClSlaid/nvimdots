local M = {}

M.setup = function()
	-- The pinned neoconf uses buffer scope for the window-local 'spell' option.
	-- Keep its notifications visible, but fix the callback for Neovim 0.12.
	require("neoconf.util").notify = function(message, level)
		vim.notify(message, level, {
			title = "neoconf.nvim",
			on_open = function(win)
				vim.wo[win].conceallevel = 3
				vim.wo[win].spell = false
				vim.bo[vim.api.nvim_win_get_buf(win)].filetype = "markdown"
			end,
		})
	end
	require("modules.utils").load_plugin("neoconf", {
		-- send new configuration to lsp clients when changing json settings
		live_reload = true,
		-- name of the local settings files
		local_settings = ".neoconf.json",
		-- name of the global settings file in your Neovim config directory
		global_settings = "neoconf.json",
		-- import existing settings from other plugins
		import = {
			vscode = true, -- local .vscode/settings.json
			coc = true, -- global/local coc-settings.json
			nlsp = true, -- global/local nlsp-settings.nvim json settings
		},
	})
end

return M
