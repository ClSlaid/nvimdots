local lang = {}

lang["nvim-orgmode/orgmode"] = {
	lazy = true,
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
	ft = { "go", "gomod", "gosum" },
	build = ":GoInstallBinaries",
	config = require("lang.go"),
}
lang["mrcjkb/rustaceanvim"] = {
	lazy = false,
	ft = "rust",
	version = "*",
	init = require("lang.rust"),
	dependencies = "nvim-lua/plenary.nvim",
}

lang["pmizio/typescript-tools.nvim"] = {
	lazy = true,
	ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "js", "ts", "mjs", "jsx", "tsx" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = require("lang.typescript-tools"),
}

lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufEnter Cargo.toml",
	config = require("lang.crates"),
	dependencies = "nvim-lua/plenary.nvim",
}
lang["MeanderingProgrammer/render-markdown.nvim"] = {
	lazy = true,
	ft = { "markdown", "codecompanion" },
	config = require("lang.render-markdown"),
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
	init = require("lang.haskell-tools"),
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
	lazy = false, -- VimTeX must register its own FileType hooks before the first TeX buffer.
	init = require("lang.vimtex"),
}

lang["eraserhd/parinfer-rust"] = {
	lazy = true,
	ft = { "scheme", "racket", "clojure", "lisp", "fennel" },
	cond = vim.fn.executable("cargo") == 1,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
	},
	build = function(plugin)
		require("modules.utils.build").run({ "cargo", "build", "--release" }, plugin.dir)
	end,
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

lang["jinzhongjia/zig-lamp"] = {
	lazy = true,
	ft = { "zig" },
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "neovim/nvim-lspconfig" },
	},
}

return lang
