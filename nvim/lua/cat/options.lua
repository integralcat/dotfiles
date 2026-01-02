local opt = vim.opt
opt.swapfile = false
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true -- Enable highlighting of the current line
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.list = true -- Show some invisible characters (tabs...
opt.linebreak = true -- Wrap lines at convenient points
opt.wildmode = "longest:full,full" -- Command-line completion mode

opt.loader.enable()
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.listchars = "tab:▸  ,trail:·,space:·,nbsp:␣"
