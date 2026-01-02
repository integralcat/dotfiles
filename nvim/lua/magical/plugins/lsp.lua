return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local on_attach = function(client)
				-- Let Prettier / formatters handle formatting
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			-- TypeScript
			vim.lsp.config.ts_ls = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- ESLint (diagnostics + fixes only)
			vim.lsp.config.eslint = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Lua
			vim.lsp.config.lua_ls = {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			}

			vim.lsp.enable({
				"ts_ls",
				"eslint",
				"lua_ls",
			})
		end,
	},
}
