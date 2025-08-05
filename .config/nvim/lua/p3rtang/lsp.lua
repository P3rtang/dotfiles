vim.filetype.add({ extension = { templ = "templ" } })

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

local format_sync_grp = vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go", "*.rs", "*.gleam" },
    callback = function() vim.lsp.buf.format { async = true } end,
    group = format_sync_grp,
})

require("mason").setup()

lspconfig.zls.setup({
    cmd = { 'zls' },
    settings = {
        zls = {
            -- Whether to enable build-on-save diagnostics
            --
            -- Further information about build-on save:
            -- https://zigtools.org/zls/guides/build-on-save/
            -- enable_build_on_save = true,

            -- Neovim already provides basic syntax highlighting
            semantic_tokens = "partial",

            -- omit the following line if `zig` is in your PATH
            zig_exe_path = '~/.local/bin/zig'
        }
    }
})

lspconfig.gleam.setup({})
lspconfig.cssls.setup({
  capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } },
})

require("conform").setup({
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
