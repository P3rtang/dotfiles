vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

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

    use "ray-x/lsp_signature.nvim"

    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'

    use { 'nvim-treesitter/nvim-treesitter', tag = 'v0.9.2' }

    use 'junegunn/vim-easy-align'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    use 'alvan/vim-closetag'

    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { "nvim-telescope/telescope-file-browser.nvim" }

    use 'stevearc/dressing.nvim'

    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    use "jiangmiao/auto-pairs"
    use "lambdalisue/suda.vim"
    use 'vappolinario/cmp-clippy'

    use "kevinhwang91/nvim-bqf"

    use { "catppuccin/nvim", as = "catppuccin" }
    use { 'dracula/vim', as = 'dracula' }
    use { "nomnivore/ollama.nvim", requires = "nvim-lua/plenary.nvim" }
    use "lewis6991/gitsigns.nvim"
    use "j-hui/fidget.nvim"
    if packer_bootstrap then
        require('packer').sync()
    end

    use "vim-scripts/AnsiEsc.vim"
    use { "folke/todo-comments.nvim", requires = 'nvim-lua/plenary.nvim' }
    use { "prettier/vim-prettier", run = "yarn install" }
end)
