local map = vim.keymap.set


map('n', 'ff', ':Telescope find_files<CR>', { desc = 'Find files with Telescope' })
map('n', '<leader>r', ':source %<CR>', { noremap = true, silent = true, desc = 'Reload current file' })
map('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
map('n', '<Esc>', ':noh<CR>', { noremap = true, desc = 'Remove Highlight' })
