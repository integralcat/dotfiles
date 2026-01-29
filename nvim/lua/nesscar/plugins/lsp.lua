return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			local on_attach = function(client, bufnr)
				-- check if any external formatter is attached to this buffer
				local has_formatter = false

				for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					if c.name == "null-ls" or c.name == "none-ls" then
						has_formatter = true
						break
					end
				end

				-- disable LSP formatting ONLY if external formatter exists
				if has_formatter then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
			end

			-- Hover popup
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			-- Minimal diagnostics
			-- vim.diagnostic.config({
			-- 	virtual_text = {
			-- 		prefix = "●", -- minimal dot
			-- 		spacing = 2,
			-- 		source = false,
			-- 	},
			-- 	signs = {
			-- 		text = {
			-- 			[vim.diagnostic.severity.ERROR] = "✘",
			-- 			[vim.diagnostic.severity.WARN] = "▲",
			-- 			[vim.diagnostic.severity.INFO] = "",
			-- 			[vim.diagnostic.severity.HINT] = "●",
			-- 		},
			-- 	},
			-- 	underline = true,
			-- 	update_in_insert = false,
			-- 	severity_sort = true,
			-- 	float = {
			-- 		border = "rounded",
			-- 		source = "if_many",
			-- 	},
			-- })

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
