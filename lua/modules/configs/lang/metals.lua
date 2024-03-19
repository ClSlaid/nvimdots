return function()
	local conf = require("metals").bare_config()
	conf.settings = {
		showImplicitArguments = true,
		excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
	}
	conf.init_options.statusBarProvider = "on"
	-- conf.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	require("metals").setup_dap()
	require("metals").initialize_or_attach(conf)
end
