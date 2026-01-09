local opts = { noremap = true, silent = true }

local map = vim.keymap.set

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gd", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)

-- Buffer Navigation
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", function()
	vim.cmd("bdelete")
end)

map("n", "<C-t>", ":tabnew<CR>")
map("n", "<C-x>", ":tabclose<CR>")
map("n", "<leader>x", ":bd<CR>") -- close the current buffer
map("n", "H", ":tabprevious<CR>")
map("n", "L", ":tabnext<CR>")
map("n", "<Esc>", ":noh<CR><Esc>")

map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- inline git inline diff
map("n", "<leader>gd", ":Gitsigns preview_hunk_inline<CR>")

-- conform powered formatting
map("n", "<C-f>", function()
	require("conform").format({ async = true, lsp_fallback = false })
end, { desc = "Format file (conform)" })

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true })
end, {})
