local lang = {}

lang["nvim-orgmode/orgmode"] = {
	-- lazy = true,
	ft = { "org" },
	config = require("lang.orgmode"),
}

lang["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	ft = "qf",
	config = require("lang.bqf"),
	dependencies = {
		{ "junegunn/fzf", build = ":call fzf#install()" },
	},
}
lang["ray-x/go.nvim"] = {
	lazy = true,
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "CmdlineEnter" },
	config = require("lang.go-nvim"),
	ft = { "go", "gomod", "gosum" },
	build = ":GoInstallBinaries",
}
lang["mrcjkb/rustaceanvim"] = {
	lazy = false,
	ft = "rust",
	version = "*",
	init = require("lang.rust"),
	dependencies = { "nvim-lua/plenary.nvim" },
}

lang["pmizio/typescript-tools.nvim"] = {
	lazy = true,
	ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "js", "ts", "mjs", "jsx", "tsx" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = require("lang.typescript-tools"),
}

lang["Saecki/crates.nvim"] = {
	lazy = true,
	-- event = "BufReadPost Cargo.toml",
	event = "BufEnter Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["MeanderingProgrammer/render-markdown.nvim"] = {
	lazy = true,
	ft = "markdown",
	config = require("lang.render-markdown"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
	},
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

lang["mrcJkb/haskell-tools.nvim"] = {
	lazy = false,
	ft = { "hs", "lhs", "haskell", "lhaskell", "cabal", "stack", "cabalproject" },
	config = require("lang.haskell-tools"),
	version = "^4",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" }, -- optional
	},
}

lang["scalameta/nvim-metals"] = {
	lazy = true,
	ft = { "scala", "sbt", "scala2", "scala3" },
	config = require("lang.metals"),
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "mfussenegger/nvim-dap" },
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

lang["chomosuke/typst-preview.nvim"] = {
	lazy = true,
	ft = { "typ", "typst" },
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	config = require("lang.typst-preview"),
}

return lang
