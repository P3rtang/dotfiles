vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'dracula/vim'
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Mason
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"

    use 'simrat39/rust-tools.nvim'

    -- Debugging
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'   

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lua'

    use 'junegunn/vim-easy-align'
    
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    
    use "jiangmiao/auto-pairs" 
    use "lambdalisue/suda.vim"
    use 'vappolinario/cmp-clippy'
    use { "catppuccin/nvim", as = "catppuccin" }
    use { 'dracula/vim', as = 'dracula' }
end)
