vim.g.mapleader = " "
vim.g.localmapleader = "\\"

require("nesscar.keymaps")
require("nesscar.lazy")
require("nesscar.options")

local opt = vim.opt

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
