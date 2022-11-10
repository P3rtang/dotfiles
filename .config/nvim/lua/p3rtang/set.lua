vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd[[colorscheme dracula]]

vim.opt.smartindent = true
vim.api.nvim_set_hl(0, 'LineNrAbove', {ctermfg='darkgrey'})
vim.api.nvim_set_hl(0, 'LineNrBelow', {ctermfg='grey'})

vim.api.nvim_set_hl(0, 'Normal', {ctermbg='none'})
vim.cmd[[
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_b = airline#section#create(['branch'])
]]
