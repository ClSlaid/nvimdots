return vim.schedule_wrap(function()
	vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {})

	require("modules.utils").load_plugin("nvim-treesitter", {})

	local languages = require("core.settings").treesitter_deps
	if #languages > 0 and vim.fn.executable("tree-sitter") == 0 then
		vim.notify(
			"Install tree-sitter-cli (>= 0.26.1), then restart Neovim to install the configured parsers.",
			vim.log.levels.WARN
		)
		return
	end
	require("nvim-treesitter").install(languages)
end)
