local lang = {}
local conf = require("modules.lang.config")

lang["fatih/vim-go"] = {
	opt = true,
	ft = "go",
	run = ":GoInstallBinaries",
	config = conf.lang_go,
}
lang["simrat39/rust-tools.nvim"] = {
	opt = true,
	ft = "rust",
	config = conf.rust_tools,
	requires = { { "nvim-lua/plenary.nvim", opt = false } },
}
-- lang["kristijanhusak/orgmode.nvim"] = {
-- 	opt = true,
-- 	ft = "org",
-- 	config = conf.lang_org,
-- }
lang["iamcco/markdown-preview.nvim"] = {
	opt = true,
	ft = "markdown",
	run = "cd app && yarn install",
}

lang["wlangstroth/vim-racket"] = {
	opt = true,
	ft = { "scheme", "racket" },
}
lang["Olical/conjure"] = {
	opt = true,
	ft = { "racket", "scheme", "clojure", "common lisp" },
}

lang["MrcJkb/haskell-tools.nvim"] = {
	opt = true,
	ft = { "haskell", "lhaskell", "cabal", "stack" },
	config = conf.haskell_tools,
	requires = {
		{ "neovim/nvim-lspconfig", opt = false },
		{ "nvim-lua/plenary.nvim", opt = false },
		{ "nvim-telescope/telescope.nvim", opt = true }, -- optional
	},
}

lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }

lang["lervag/vimtex"] = {
	opt = true,
	ft = { "latex", "tex" },
	config = conf.vimtex,
}

return lang
