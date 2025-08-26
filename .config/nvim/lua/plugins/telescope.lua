return {
    { 
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        depenencies = 'nvim-lua/plenary.nvim',
        opts = {
            defaults = {
                layout_strategy = 'vertical',
            }
        } 
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
