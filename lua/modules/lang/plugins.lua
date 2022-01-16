local lang = {}
local conf = require("modules.lang.config")

lang['fatih/vim-go'] = {
    opt = true,
    ft = 'go',
    run = ':GoInstallBinaries',
    config = conf.lang_go
}
lang["rust-lang/rust.vim"] = {opt = true, ft = "rust"}
lang["simrat39/rust-tools.nvim"] = {
    opt = true,
    ft = "rust",
    config = conf.rust_tools,
    requires = {{"nvim-lua/plenary.nvim", opt = false}}
}
-- lang["kristijanhusak/orgmode.nvim"] = {
--     opt = true,
--     ft = "org",
--     config = conf.lang_org
-- }
lang["iamcco/markdown-preview.nvim"] = {
    opt = true,
    ft = "markdown",
    run = "cd app && yarn install"
}

lang['wlangstroth/vim-racket'] = {
    opt = true,
    ft = {"scheme", "racket"},
}
lang['Olical/conjure'] = {
    opt = true,
    ft = {"racket", "scheme", "clojure", "common lisp"},
}
lang['neovimhaskell/haskell-vim'] = {
    opt = true,
    ft = "haskell",
    config = conf.haskell
}

lang["chrisbra/csv.vim"] = {opt = true, ft = "csv"}

return lang
