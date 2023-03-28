return function()
	local conf = {
		org_agenda_files = { "~/org/**/*" },
		org_default_notes_file = "~/org/refile.org",
	}
	require("orgmode").setup_ts_grammar()
	require("orgmode").setup(conf)
end
