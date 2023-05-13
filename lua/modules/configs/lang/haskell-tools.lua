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
				stylize_markdown = true,
				-- Whether to automatically switch to the hover window
				auto_focus = false,
			},
			definition = {
				-- Configure vim.lsp.definition to fall back to hoogle search
				-- (does not affect vim.lsp.tagfunc)
				hoogle_signature_fallback = true,
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
		hls = { -- LSP client options
			-- ...
			settings = {
				haskell = {
					-- The formatting providers.
					formattingProvider = "stylish-haskell",
					cabalFormattingProvider = "cabalfmt",
					-- Maximum number of completions sent to the LSP client.
					maxCompletions = 40,
					-- Whether to typecheck the entire project on initial load.
					-- Could drive to bad performance in large projects, if set to true.
					checkProject = true,
					-- When to typecheck reverse dependencies of a file;
					-- one of NeverCheck, CheckOnSave (means dependent/parent modules will only be checked when you save),
					-- or AlwaysCheck (means re-typechecking them on every change).
					checkParents = "CheckOnSave",
					plugin = {
						alternateNumberFormat = { globalOn = true },
						callHierarchy = { globalOn = true },
						changeTypeSignature = { globalOn = true },
						class = {
							codeActionsOn = true,
							codeLensOn = true,
						},
						eval = {
							globalOn = true,
							config = {
								diff = true,
								exception = true,
							},
						},
						excplicitFixity = { globalOn = true },
						gadt = { globalOn = true },
						["ghcide-code-actions-bindings"] = { globalOn = true },
						["ghcide-code-actions-fill-holes"] = { globalOn = true },
						["ghcide-code-actions-imports-exports"] = { globalOn = true },
						["ghcide-code-actions-type-signatures"] = { globalOn = true },
						["ghcide-completions"] = {
							globalOn = true,
							config = {
								autoExtendOn = true,
								snippetsOn = true,
							},
						},
						["ghcide-hover-and-symbols"] = {
							hoverOn = true,
							symbolsOn = true,
						},
						["ghcide-type-lenses"] = {
							globalOn = true,
							config = {
								mode = "always",
							},
						},
						haddockComments = { globalOn = true },
						hlint = {
							codeActionsOn = true,
							diagnosticsOn = true,
						},
						importLens = {
							globalOn = true,
							codeActionsOn = true,
							codeLensOn = true,
						},
						moduleName = { globalOn = true },
						pragmas = {
							codeActionsOn = true,
							completionOn = true,
						},
						qualifyImportedNames = { globalOn = true },
						refineImports = {
							codeActionsOn = true,
							codeLensOn = true,
						},
						rename = {
							globalOn = true,
							config = { crossModule = true },
						},
						retrie = { globalOn = true },
						splice = { globalOn = true },
						tactics = {
							codeActionsOn = true,
							codeLensOn = true,
							config = {
								auto_gas = 4,
								hole_severity = nil,
								max_use_ctor_actions = 5,
								proofstate_styling = true,
								timeout_duration = 2,
							},
							hoverOn = true,
						},
					},
				},
			},
		},
	}
	require("haskell-tools").start_or_attach(opts)
end
