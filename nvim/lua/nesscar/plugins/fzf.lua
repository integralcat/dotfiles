return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.85,
				preview = {
					layout = "right",
					width = 0.6,
				},
			},
			files = {
				fd_opts = "--hidden --exclude .git",
			},
			grep = {
				rg_opts = "--hidden --glob '!.git/*'",
			},
		})
	end,
}
