vim.filetype.add({ extension = { templ = "templ" } })

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
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
