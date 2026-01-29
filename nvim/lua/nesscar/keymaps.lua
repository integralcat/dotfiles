local opts = { noremap = true, silent = true }

local map = vim.keymap.set

-- LSP Definition and References
map("n", "<leader>e", ":Lexplore<CR>", opts)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gd", vim.lsp.buf.references)
map("n", "K", vim.lsp.buf.hover)
map("i", "<C-k>", vim.lsp.buf.signature_help)
map("n", "<C-k>", vim.lsp.buf.signature_help)

-- Buffer Navigation
map("n", "bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "bp", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "bd", function()
	vim.cmd("bdelete")
end)

-- Ctrl + V to Paste
map("n", "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })

if vim.g.neovide then
	vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- Diagnostics
map("n", "<leader>d", function()
	vim.diagnostic.open_float(nil, {
		focus = false,
		close_events = { "CursorMoved", "BufHidden", "InsertEnter" },
	})
end)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- Tabs
map("n", "<C-t>", ":tabnew<CR>")
map("n", "<C-x>", ":tabclose<CR>")
map("n", "<leader>x", ":bd<CR>") -- Close the current buffer
map("n", "H", ":tabprevious<CR>")
map("n", "L", ":tabnext<CR>")
map("n", "<Esc>", ":noh<CR><Esc>")

-- SPLITS (| and -)
map("n", "<leader>\\", "<cmd>vsplit<CR>", opts)
map("n", "<leader>-", "<cmd>split<CR>", opts)

-- MOVE BETWEEN PANES (hjkl)
-- map("n", "<leader>h", "<C-w>h", opts)
-- map("n", "<leader>j", "<C-w>j", opts)
-- map("n", "<leader>k", "<C-w>k", opts)
-- map("n", "<leader>l", "<C-w>l", opts)

-- RESIZE PANES (H J K L)
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- CLOSE / FOCUS PANES
map("n", "<C-w>x", "<cmd>close<CR>", opts)
map("n", "<C-w>o", "<cmd>only<CR>", opts)

-- TABS = TMUX WINDOWS
map("n", "<leader>c", "<cmd>tabnew<CR>", opts)
map("n", "<leader>zz", "<cmd>tab split<CR>", opts)
map("n", "<leader><C-h>", "<cmd>tabprevious<CR>", opts)
map("n", "<leader><C-l>", "<cmd>tabnext<CR>", opts)

-- inline git inline diff
map("n", "<leader>gd", ":Gitsigns preview_hunk_inline<CR>")

-- conform powered formatting
map("n", "<C-f>", function()
	require("conform").format({ async = true, lsp_fallback = false })
end, { desc = "Format file (conform)" })

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true })
end, {})

-- Close any floating window
vim.keymap.set("n", "<Esc>", function()
	-- close any floating window first
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.relative ~= "" then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	-- no floats → clear search highlight
	vim.cmd("noh")
end, { silent = true })
