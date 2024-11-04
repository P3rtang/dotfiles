package.path = "../../init.lua"
require("helper_func")

-- Vim keybinds
vim.keymap.set('n', '<C-s>', vim.cmd.wa, {})
vim.keymap.set('n', '<esc>', ":noh<CR>", {})
vim.keymap.set('t', '<esc>', '<cmd>bd!<CR>')
vim.keymap.set('n', '<leader>ss', function ()
    ReloadConfig()
end, {})

-- copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, remap = false })

-- navigation
vim.keymap.set('n', 'gt', vim.cmd.tabnext, {})
vim.keymap.set('n', 'gT', vim.cmd.tabprevious, {})
vim.keymap.set('n', 'gb', vim.cmd.bn, {})
vim.keymap.set('n', 'gB', vim.cmd.bp, {})
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { noremap = true })
vim.keymap.set('n', '<leader>bD', "<cmd>bd#<CR>", {})

-- Editing
vim.keymap.set('n', '<M-j>', "<cmd>m +1<CR>")
vim.keymap.set('n', '<M-k>', "<cmd>m -2<CR>")

-- Spell Checking
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = 'camel'
vim.keymap.set('n', '<leader>cs', function ()
    vim.opt.spell = not(vim.opt.spell:get())
end, {})

-- Telescope keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', require "telescope".extensions.file_browser.file_browser, {})
vim.keymap.set('n', '<leader>ll', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>lt', vim.cmd.TodoTelescope, {})

-- make + quickfix
vim.opt.errorformat = {
    -- rust
    "%Eerror[E%n]: %m,%Z%.%#--> %f:%l:%c",
    "%Wwarning: %m,%Z%.%#--> %f:%l:%c",

    -- zig
    "%f:%l:%c: error: %m",

    -- ignore if file is in zig std lib
    "%-C%.%#packages%.%#",
    "%-G%.%#packages%.%#",

    -- zig file in test output
    "%Z%f:%l:%c: %.%#",

    "%f:%l:%c: %.%#",


    "%E%.%# panic: %m",

    -- info
    "%f:%l:%c: [%tNFO] %m",
    "%f:%l: [%tNFO] %m",
}

vim.opt.makeprg = "make"

vim.keymap.set('n', '<leader>mm', function ()
    vim.cmd.make()
    CheckQuickfix()
end, { noremap = true })

vim.keymap.set('n', '<leader>mt', function ()
    vim.opt.makeprg = "make test"
    vim.cmd.make()
    vim.opt.makeprg = "make"
end)

vim.keymap.set('n', '<leader>mc', function()
    local old_make = vim.opt.makeprg
    vim.opt.makeprg = "make check"
    vim.cmd.make()
    CheckQuickfix()
    vim.opt.makeprg = old_make
end, { noremap = true })
vim.keymap.set('n', '<leader>co', vim.cmd.copen)
vim.keymap.set('n', '<leader>cn', function()
    vim.cmd.cn()
    vim.cmd.copen()
end, { noremap = true })
vim.keymap.set('n', '<leader>cp', function ()
    vim.cmd.cp()
    vim.cmd.copen()
end, { noremap = true })

-- LSP keybinds
local opts = { noremap = true, silent = true }
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
