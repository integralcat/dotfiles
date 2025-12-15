return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvimtools/none-ls-extras.nvim" },
	event = "VeryLazy",

	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.stylua,
			},
		})

		-- Define :Format command (sync to make it feel instant)
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ async = false })
		end, { desc = "Format current buffer" })
	end,
}
