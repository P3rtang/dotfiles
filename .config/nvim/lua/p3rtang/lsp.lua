local lspconfig = require("lspconfig")

vim.filetype.add({ extension = { templ = "templ" } })
vim.cmd("au BufWritePre *.tsx,*.ts,*.js,*.html,*.css  Prettier")

local on_attach = function(_, bufnr)
    -- Enable function signatures
    require("lsp_signature").setup()
    require "lsp_signature".on_attach(signature_setup, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.keymap.set('n', 'E', vim.diagnostic.open_float)
    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover()
        vim.lsp.buf.hover()
    end)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "single"
    }
)

vim.diagnostic.config{
    float={border="single"}
}

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "rust_analyzer", "cssls", "cssmodules_ls", "pyright", "gopls" },
    handlers = {
        function (lsp)
            lspconfig[lsp].setup{ on_attach = on_attach }
        end,
        ["rust_analyzer"] = function ()
            lspconfig["rust_analyzer"].setup {
                on_attach = on_attach,
                root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
                settings = {
                    ["rust-analyzer"] = {
                        ["cargo"] = {
                            ["allFeatures"] = true,
                        },
                    }
                }
            }
        end,
        ["gopls"] = function ()
            lspconfig["gopls"].setup {
                on_attach = on_attach,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            }
        end,
        ["lua_ls"] = function ()
            lspconfig["lua_ls"].setup {
                on_init = function(client)
                    if (client.config.settings.Lua == nil) then
                        client.config.settings.Lua = {}
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })
                end
            }
        end
    }
}
