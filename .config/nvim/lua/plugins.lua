vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'dracula/vim'
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

    use 'williamboman/mason.nvim'    
    use 'williamboman/mason-lspconfig.nvim'
    
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lua'
    
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "nvim-lua/plenary.nvim"
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    -- You add plugins here  
end)
