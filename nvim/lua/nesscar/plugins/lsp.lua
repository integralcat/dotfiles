return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			local on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			-- Hover popup (keep this)
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			-- Servers
			vim.lsp.config.tsserver = { on_attach = on_attach, capabilities = capabilities }
			vim.lsp.config.eslint = { on_attach = on_attach, capabilities = capabilities }
			vim.lsp.config.lua_ls = {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = { diagnostics = { globals = { "vim" } } },
				},
			}
			vim.lsp.config.clangd = { on_attach = on_attach, capabilities = capabilities }
			vim.lsp.config.pyright = { capabilities = capabilities }

			vim.lsp.enable({
				"tsserver",
				"eslint",
				"lua_ls",
				"clangd",
				"pyright",
			})
		end,
	},
}
