return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "lua_ls",
        },
      })

      -- NEW Neovim 0.11 API
      vim.lsp.config.ts_ls = {
        on_attach = function(client)
          -- disable formatting (Prettier handles it)
          client.server_capabilities.documentFormattingProvider = false
        end,
      }

      vim.lsp.config.eslint = {}

      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }

      -- enable servers
      vim.lsp.enable({
        "ts_ls",
        "eslint",
        "lua_ls",
      })
    end,
  },
}
