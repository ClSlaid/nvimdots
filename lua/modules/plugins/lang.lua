local lang = {}

lang["nvim-orgmode/orgmode"] = {
	-- lazy = true,
	ft = { "org" },
	config = require("lang.orgmode"),
}

lang["ray-x/go.nvim"] = {
	lazy = true,
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "go", "gomod" },
	event = { "CmdlineEnter" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	config = require("lang.go-nvim"),
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "nvim-telescope/telescope.nvim" }, -- optional
		{ "mattn/webapi-vim" }, -- optional
	},
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
	lazy = true,
	ft = { "scheme", "racket" },
}

lang["MrcJkb/haskell-tools.nvim"] = {
	lazy = true,
	ft = { "hs", "lhs", "haskell", "lhaskell", "cabal", "stack" },
	config = require("lang.haskell-tools"),
	dependencies = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" }, -- optional
	},
}

lang["lervag/vimtex"] = {
	lazy = true,
	ft = { "latex", "tex" },
	dependencies = {
		{ "neovim/nvim-lspconfig" },
	},
	config = require("lang.vimtex"),
}

lang["eraserhd/parinfer-rust"] = {
	lazy = true,
	ft = { "scheme", "guile", "scheme.guile", "scm", "cljr", "rkt", "cl" },
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
	},
	build = "cargo clean && cargo build --release",
}

lang["Julian/lean.nvim"] = {
	lazy = true,
	ft = { "lean", "lean3", "lean4" },
	dependencies = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
	},
	config = require("lang.lean"),
}

return lang
