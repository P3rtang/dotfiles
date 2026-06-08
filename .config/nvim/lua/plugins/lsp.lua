local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local on_attach = function(_, bufnr)
	-- Enable function signatures
	require("lsp_signature").setup()
	require("lsp_signature").on_attach(signature_setup, bufnr)

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, bufopts)
	vim.keymap.set("n", "]g", vim.diagnostic.goto_next, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
	vim.keymap.set("n", "E", vim.diagnostic.open_float)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
		vim.lsp.buf.hover()
	end)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- CRITICAL: You must use main on Neovim 0.12+
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			-- 1. Explicitly queue and install your language ecosystem
			local parsers = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"go",
				"rust",
				"zig",
				"markdown",
				"markdown_inline",
			}
			ts.install(parsers) -- Modern main API to register parsers

			-- 2. NATIVE ACTIVATION: The new way to enable features for your languages
			local ts_group = vim.api.nvim_create_augroup("NativeTreesitterSetup", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = ts_group,
				pattern = parsers,
				callback = function(args)
					-- Global Fold Configuration:
					-- Set the fold level very high so files open fully expanded by default.
					vim.opt.foldlevel = 99
					vim.opt.foldlevelstart = 99

					-- Turn on native tree-sitter AST syntax highlighting for this buffer
					vim.treesitter.start(args.buf)

					-- Optional: Turn on smart language indentation
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- Optional: Map native code-folding using Tree-sitter objects
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		name = "lspconfig",
		config = function()
			vim.lsp.config("gleam", { virtual_text = true })

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 200,
				lsp_format = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
				sql = { "pg_format" },
			},
		},
	},
	{ "ray-x/lsp_signature.nvim" },
	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		dependencies = {
			"neovim/nvim-lspconfig",
			{
				"williamboman/mason.nvim",
				name = "mason",
				dependencies = "lspconfig",
				opts = {},
			},
		},
		config = function()
			require("mason-lspconfig").setup({})

			vim.lsp.config("*", {
				on_attach = on_attach,
			})

			vim.lsp.config("rust_analyzer", {
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						["cargo"] = {
							["allFeatures"] = true,
						},
					},
				},
			})

			vim.lsp.config("gopls", {
				on_attach = on_attach,
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
}
