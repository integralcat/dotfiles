return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local null_ls = require("null-ls")
		local builtins = null_ls.builtins

		return {
			sources = {
				-- Lua
				builtins.formatting.stylua,

				-- Web
				builtins.formatting.prettierd.with({
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"typescript",
						"json",
					},
				}),
			},
		}
	end,
}
