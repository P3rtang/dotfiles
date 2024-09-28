local vim = vim
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.numberwidth = 5
vim.opt.autoindent  = true
vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 12
vim.opt.updatetime = 100

vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
})

vim.cmd.colorscheme "catppuccin"

vim.cmd[[
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_b = airline#section#create(['branch'])
    let g:airline_theme = 'catppuccin'
]]

vim.api.nvim_set_hl(0, 'LineNrAbove', {ctermfg='darkgrey'})
vim.api.nvim_set_hl(0, 'LineNrBelow', {ctermfg='grey'})
vim.api.nvim_set_hl(0, 'Normal', {ctermbg='none'})

require("ollama").setup()
require('gitsigns').setup()
require('fidget').setup()
require('todo-comments').setup()
