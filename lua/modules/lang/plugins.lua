local lang = {}
local conf = require("modules.lang.config")

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = conf.lang_go,
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = conf.rust_tools,
	dependencies = { { "nvim-lua/plenary.nvim" } },
}
lang["Saecki/crates.nvim"] = {
	opt = true,
	ft = "rust",
	config = conf.crates,
	requires = "nvim-lua/plenary.nvim",
}

lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}

lang["wlangstroth/vim-racket"] = {
	opt = true,
	ft = { "scheme", "racket" },
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

lang["lervag/vimtex"] = {
	opt = true,
	ft = { "latex", "tex" },
	requires = {
		{ "neovim/nvim-lspconfig", opt = false },
	},
	config = conf.vimtex,
}

return lang
