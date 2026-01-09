return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"ts_ls",
			"eslint",
			"html",
			"cssls",
			"clangd",
			"rust_analyzer",
			"pyright",
			"ruff",
		},
	},
}
