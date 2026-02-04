return {
	{ "tpope/vim-fugitive" },
	{
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR 'ibhagwan/fzf-lua',
			-- OR 'folke/snacks.nvim',
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({
				mappings = {
					issue = {
						list_issues = { lhs = "<leader>li", desc = "Octo: review | list open issues on current repo" },
					},
					pull_request = {
						add_comment = { lhs = "<leader>om", desc = "Octo: pr | add comment" },
					},
					review_thread = {
						add_comment = { lhs = "<leader>om", desc = "Octo: thread | add comment" },
					},
					review_diff = {
						add_review_suggestion = {
							lhs = "<leader>os",
							desc = "add a new review suggestion",
							mode = { "n", "x" },
						},
						add_review_comment = {
							lhs = "<leader>om",
							desc = "Octo: review | add a new review comment",
							mode = { "n", "x" },
						},
						select_next_entry = { lhs = "<leader>ol", desc = "Octo: review | move to next changed file" },
						select_prev_entry = {
							lhs = "<leader>oh",
							desc = "Octo: review | move to previous changed file",
						},
						toggle_viewed = { lhs = "<leader>od", desc = "Octo: review | toggle viewer viewed state" },
						goto_file = { lhs = "gf", desc = "Octo: review | go to file" },
					},
				},
			})
		end,
	},
}
