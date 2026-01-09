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
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles)

		-- Ripgrep
		vim.keymap.set("n", "<leader>fg", builtin.live_grep)
		vim.keymap.set("n", "<leader>/", function()
			builtin.live_grep({ grep_open_files = true })
		end)

		-- LSP (keep native jumps fast)
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
		vim.keymap.set("n", "<leader>;", builtin.resume)

		--------------------------------------------------
		-- Telescope Setup
		--------------------------------------------------

		telescope.setup({
			defaults = {
				-- UI
				prompt_prefix = "   ",
				selection_caret = "❯ ",
				entry_prefix = "  ",
				initial_mode = "insert",

				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				winblend = 10,

				layout_config = {
					prompt_position = "top",
					preview_width = 0.55,
					width = 0.85,
					height = 0.75,
				},

				border = true,
				borderchars = {
					prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
					preview = { "─", "│", "─", "│", "┐", "┐", "┘", "└" },
				},

				path_display = { "truncate" },

				-- rg
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob",
					"!.git/*",
				},

				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
					"build",
				},

				-- Keymaps
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
				-- fd
				find_files = {
					find_command = {
						"fd",
						"--type",
						"f",
						"--hidden",
						"--follow",
						"--exclude",
						".git",
					},
					previewer = false,
					layout_config = { width = 0.6 },
				},

				buffers = {
					previewer = false,
					layout_config = { width = 0.6 },
				},

				oldfiles = {
					previewer = false,
					layout_config = { width = 0.6 },
				},

				-- Code-aware pickers (preview ON)
				live_grep = { previewer = true },
				lsp_definitions = { previewer = true },
				lsp_references = { previewer = true },
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
