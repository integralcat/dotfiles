return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		-- Files
		vim.keymap.set("n", "<leader>ff", builtin.find_files)
		vim.keymap.set("n", "<leader>fg", builtin.live_grep)
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles)

		-- LSP
		vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		vim.keymap.set("n", "gr", vim.lsp.buf.references)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)

		-- Git
		vim.keymap.set("n", "<leader>gs", builtin.git_status)
		vim.keymap.set("n", "<leader>gc", builtin.git_commits)
		vim.keymap.set("n", "<leader>gb", builtin.git_branches)

		-- Utils
		vim.keymap.set("n", "<leader>km", builtin.keymaps)
		vim.keymap.set("n", "<leader>/", function()
			builtin.live_grep({ grep_open_files = true })
		end)
		vim.keymap.set("n", "<leader>;", builtin.resume)

		telescope.setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "❯ ",
				entry_prefix = "  ",
				initial_mode = "insert",

				sorting_strategy = "ascending",
				layout_strategy = "horizontal",

				layout_config = {
					prompt_position = "top",
					preview_width = 0.5,
					width = 0.75,
					height = 0.65,
				},

				border = true,
				borderchars = {
					prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
					preview = { "─", "│", "─", "│", "┐", "┐", "┘", "└" },
				},

				winblend = 10,

				path_display = { "truncate" },

				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
					"build",
				},

				preview = {
					filesize_limit = 0.3, -- MB
					timeout = 200,
					treesitter = true,
				},

				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<Esc>"] = actions.close,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},

			pickers = {
				buffers = {
					previewer = false,
					layout_config = { width = 0.6 },
				},
				oldfiles = {
					previewer = false,
					layout_config = { width = 0.6 },
				},
				find_files = {
					previewer = false,
					layout_config = { width = 0.6 },
				},

				-- Code-aware pickers (preview ON)
				live_grep = {
					previewer = true,
				},
				lsp_definitions = {
					previewer = true,
				},
				lsp_references = {
					previewer = true,
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
