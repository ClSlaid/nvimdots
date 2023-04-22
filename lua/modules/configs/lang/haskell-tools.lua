return function()
	local opts = {
		tools = { -- haskell-tools options
			codeLens = {
				-- Whether to automatically display/refresh codeLenses
				-- (explicitly set to false to disable)
				autoRefresh = true,
			},
			hoogle = {
				-- 'auto': Choose a mode automatically, based on what is available.
				-- 'telescope-local': Force use of a local installation.
				-- 'telescope-web': The online version (depends on curl).
				-- 'browser': Open hoogle search in the default browser.
				mode = "auto",
			},
			hover = {
				-- Whether to disable haskell-tools hover and use the builtin lsp's default handler
				disable = false,
				-- Set to nil to disable
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				-- Stylize markdown (the builtin lsp's default behaviour).
				-- Setting this option to false sets the file type to markdown and enables
				-- Treesitter syntax highligting for Haskell snippets if nvim-treesitter is installed
				stylize_markdown = false,
				-- Whether to automatically switch to the hover window
				auto_focus = false,
			},
			definition = {
				-- Configure vim.lsp.definition to fall back to hoogle search
				-- (does not affect vim.lsp.tagfunc)
				hoogle_signature_fallback = false,
			},
			repl = {
				-- 'builtin': Use the simple builtin repl
				-- 'toggleterm': Use akinsho/toggleterm.nvim
				handler = "builtin",
				builtin = {
					create_repl_window = function(view)
						-- create_repl_split | create_repl_vsplit | create_repl_tabnew | create_repl_cur_win
						return view.create_repl_split({ size = vim.o.lines / 3 })
					end,
				},
			},
			-- Set up autocmds to generate tags (using fast-tags)
			-- e.g. so that `vim.lsp.tagfunc` can fall back to Haskell tags
			tags = {
				enable = vim.fn.executable("fast-tags") == 1,
				-- Events to trigger package tag generation
				package_events = { "BufWritePost" },
			},
		},
		-- hls = { -- LSP client options
		-- 	-- ...
		-- 	settings = {
		-- 		haskell = { -- haskell-language-server options
		-- 			formattingProvider = "fourmolu",
		-- 			checkProject = true, -- Setting this to true could have a performance impact on large mono repos.
		--                   plugin = {
		--                       rename = {
		--                           globalOn = true,
		--                           config = {
		--                               crossModule = true,
		--                           }
		--                       }
		--                   }
		-- 			-- ...
		-- 		},
		-- 	},
		-- },
	}
	require("haskell-tools").setup(opts)
end
