return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				auto_integrations = true,
				flavour = "macchiato", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
			})

			vim.cmd([[colorscheme catppuccin]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "catppuccin",
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
