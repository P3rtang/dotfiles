return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function ()
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

            vim.cmd([[colorscheme catppuccin]])
        end
    },
    {
        'vim-airline/vim-airline', config = function ()
            vim.cmd[[
                let g:airline#extensions#tabline#enabled = 1
                let g:airline_section_b = airline#section#create(['branch'])
                let g:airline_theme = 'catppuccin'
            ]]
        end
    },
    { 'vim-airline/vim-airline-themes' },
    {
        'mikesmithgh/borderline.nvim',
        enabled = true,
        lazy = true,
        event = 'VeryLazy',
        config = function()
            require('borderline').setup()
        end,
    }
}
