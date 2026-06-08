return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
