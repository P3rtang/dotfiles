local snip = require("snippets.luasnip");

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    { 'tpope/vim-surround' },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = snip.config
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.window = {
                completion = cmp.config.window.bordered({}),
                documentation = cmp.config.window.bordered({}),
            }

        end,
        config = function()
            local cmp = require("cmp")
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                sources = {
                    {name = 'path'},
                    {name = 'nvim_lsp', keyword_length = 1},
                    {name = 'luasnip', keyword_length = 1},
                    {name = 'buffer', keyword_length = 2},
                    {name = 'nvim_lua', keyword_length = 2},
                    {name = 'orgmode'},
                },
                window = {
                    documentation = cmp.config.window.bordered()
                },
                formatting = {
                    fields = {'menu', 'abbr', 'kind'},
                    format = function(entry, item)
                        local menu_icon = {
                            nvim_lsp = '&',
                            luasnip = '⋗',
                            buffer = 'Ω',
                            path = '🖫',
                            clippy = '>>',
                        }

                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
                mapping = {
                    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

                    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({select = true}),

                    ['<C-d>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),

                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),

                    ['<Tab>'] = cmp.mapping(function(fallback)
                        local col = vim.fn.col('.') - 1

                        if cmp.visible() then
                            cmp.select_next_item(select_opts)
                        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end, {'i', 's'}),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item(select_opts)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                },
            })
        end
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lua' },
}
