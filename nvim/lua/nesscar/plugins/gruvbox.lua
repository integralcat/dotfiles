return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- load before UI plugins
	lazy = false, -- load immediately
	opts = {
		contrast = "hard",
		transparent_mode = true,
	},
	config = function(_, opts)
		require("gruvbox").setup(opts)
		vim.cmd.colorscheme("gruvbox")

		-- For LspSignature
		-- Float background (glass)
		vim.api.nvim_set_hl(0, "NormalFloat", {
			bg = "NONE",
		})

		-- Soft border (visible but not loud)
		vim.api.nvim_set_hl(0, "FloatBorder", {
			fg = "#504945", -- Gruvbox-ish muted gray
			bg = "NONE",
		})

		-- Highlight active parameter (focus cue)
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
			fg = "#fabd2f",
			bold = true,
		})

		-- transparency tweaks for telescope
		vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "Normal" })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })
		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "Normal" })
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "DiffAdd", {
			bg = "#32361a",
			fg = "#b8bb26",
		})

		vim.api.nvim_set_hl(0, "DiffDelete", {
			bg = "#3c1f1e",
			fg = "#fb4934",
		})

		vim.api.nvim_set_hl(0, "DiffChange", {
			bg = "#2a3a3a",
			fg = "#83a598",
		})

		vim.api.nvim_set_hl(0, "DiffText", {
			bg = "#3c3836",
			fg = "#fabd2f",
			bold = true,
		})
	end,
}
