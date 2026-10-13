return function()
	local platform = require("core.global")
	if platform.is_mac then
		vim.g.vimtex_view_method = "skim"
	elseif platform.is_linux and vim.fn.executable("zathura") == 1 then
		vim.g.vimtex_view_method = "zathura"
	end -- Otherwise retain VimTeX's platform-default viewer.
	if vim.fn.executable("tectonic") == 1 then
		vim.g.vimtex_compiler_method = "tectonic"
	end
end
