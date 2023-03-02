local vim = vim
-- Vim keybinds
vim.keymap.set('n', '<C-s>',      vim.cmd.wa,            {})
vim.keymap.set('n', '<esc>',      ":noh<CR>",            {})
vim.keymap.set('n', '<C-m>',      vim.cmd.make,          {})
vim.keymap.set('n', '<C-n>',      "<cmd>make tests<CR>", {})

-- navigation
vim.keymap.set('n', 'gt', vim.cmd.tabnext, {})
vim.keymap.set('n', 'gT', vim.cmd.tabprevious, {})
vim.keymap.set('n', 'gb', vim.cmd.bn, {})
vim.keymap.set('n', 'gB', vim.cmd.bp, {})

-- Telescope keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', require "telescope".extensions.file_browser.file_browser, {})
vim.keymap.set('n', '<leader>ll', builtin.diagnostics, {})

-- LSP keybinds
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Code action

-- Align text
vim.cmd [[
    nmap <leader>al <Plug>(EasyAlign)
    xmap <leader>al <Plug>(EasyAlign)
]]
