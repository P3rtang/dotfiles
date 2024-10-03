-- Vim keybinds
vim.keymap.set('n', '<C-s>', vim.cmd.wa, {})
vim.keymap.set('n', '<esc>', ":noh<CR>", {})
vim.keymap.set('n', '<leader>mm', "<cmd>terminal make<CR>i", {})
vim.keymap.set('n', '<leader>mt', "<cmd>terminal make test<CR>i", {})
vim.keymap.set('t', '<esc>', '<cmd>bd!<CR>')

-- copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, remap = false })

-- navigation
vim.keymap.set('n', 'gt', vim.cmd.tabnext, {})
vim.keymap.set('n', 'gT', vim.cmd.tabprevious, {})
vim.keymap.set('n', 'gb', vim.cmd.bn, {})
vim.keymap.set('n', 'gB', vim.cmd.bp, {})

-- Editing
vim.keymap.set('n', '<M-j>', "<cmd>m +1<CR>")
vim.keymap.set('n', '<M-k>', "<cmd>m -2<CR>")

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
vim.keymap.set('n', '<C-n>', function ()
    vim.opt.errorformat = { "%Eerror%m,%C%.%#--> %f:%l:%c,%Z,%A,%-C,%Z" }
    vim.opt.makeprg = "make"
    vim.cmd.make()

    local function check_valid_filename(entry)
        local filename = vim.fn.bufname(entry.bufnr)
        return filename and #filename > 0 and entry.lnum ~= 0
    end

    local function filter(func, t)
        local result = {}
        for _, v in ipairs(t) do -- Using ipairs for array-like tables
            if func(v) then
                table.insert(result, v)
            end
        end
        return result
    end

    local qflist = vim.fn.getqflist()
    local filtered_qflist = filter(check_valid_filename, qflist)

    if #filtered_qflist > 0 then
        vim.cmd.copen()
    end
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
