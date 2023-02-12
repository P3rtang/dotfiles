local vim = vim
local map = vim.api.nvim_set_keymap
map('n', '<Space>', '', {})

vim.g.mapleader = ' '

require("plugins")
require("p3rtang.set")
require("p3rtang.nvim-cmp")
require("p3rtang.keybinds")
require("p3rtang.telescope")
require("p3rtang.luasnip")
require("p3rtang.commands")
require("p3rtang.rust")
-- require("p3rtang.lsp")

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "cssls", "cssmodules_ls", "pyright" },
}

require("lspconfig").cssls.setup({
    on_attach = on_attach,
    settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
})
require("lspconfig").pyright.setup{
    on_attach = on_attach
}
require("lspconfig").lua_ls.setup{
    on_attach = on_attach
}
require("lspconfig").cssmodules_ls.setup{
    on_attach = on_attach
}
