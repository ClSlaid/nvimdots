return function()
	local conf = require("metals").bare_config()
	conf.settings = {
		showImplicitArguments = true,
		excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
	}
	conf.init_options.statusBarProvider = "on"
	conf.capabilities = require("modules.utils").get_lsp_capabilities()

	require("metals").setup_dap()
	local function attach()
		require("metals").initialize_or_attach(conf)
	end
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("PersonalMetals", { clear = true }),
		pattern = { "scala", "sbt" },
		callback = attach,
	})
	attach()
end
