return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = false,
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
    },
  },
}
