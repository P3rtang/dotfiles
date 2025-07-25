local vim              = vim
vim.opt.nu             = true
vim.opt.relativenumber = true

vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.numberwidth    = 5
vim.opt.autoindent     = true
vim.opt.smartindent    = true

vim.opt.hlsearch       = true
vim.opt.incsearch      = true

vim.opt.scrolloff      = 12
vim.opt.updatetime     = 100

vim.opt.colorcolumn    = "100"
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"

vim.api.nvim_set_hl(0, 'LineNrAbove', { ctermfg = 'darkgrey' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { ctermfg = 'grey' })
vim.api.nvim_set_hl(0, 'Normal', { ctermbg = 'none' })

-- require("ollama").setup()
-- require('gitsigns').setup()
-- require('fidget').setup()

vim.diagnostic.enable = true
vim.diagnostic.config({
    virtual_lines = true,
})
