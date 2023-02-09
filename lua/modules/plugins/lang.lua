local lang = {}

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = require("lang.vim-go"),
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
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
	config = require("lang.haskell-tools"),
	dependencies = {
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
	config = require("lang.vimtex"),
}

return lang
