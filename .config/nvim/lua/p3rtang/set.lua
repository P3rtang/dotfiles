vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.numberwidth = 5

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 12
vim.opt.updatetime = 100

vim.opt.colorcolumn = "100"


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

vim.cmd.colorscheme "dracula"

vim.cmd[[
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_b = airline#section#create(['branch'])
]]

vim.opt.smartindent = true
vim.api.nvim_set_hl(0, 'LineNrAbove', {ctermfg='darkgrey'})
vim.api.nvim_set_hl(0, 'LineNrBelow', {ctermfg='grey'})
vim.api.nvim_set_hl(0, 'Normal', {ctermbg='none'})
