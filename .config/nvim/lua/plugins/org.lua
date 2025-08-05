return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		opts = {
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
			mappings = {
				org = {
					org_toggle_checkbox = "<C-c>",
				},
			},
		},
	},
	{
		"nvim-orgmode/org-bullets.nvim",
		event = "VeryLazy",
		dependencies = { "orgmode" },
		opts = {
			concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
			symbols = {
				-- list symbol
				list = "•",
				-- headlines can be a list
				headlines = { "◉", "○", "✸", "✿" },
				-- or a function that receives the defaults and returns a list
				headlines = function(default_list)
					table.insert(default_list, "♥")
					return default_list
				end,
				-- or false to disable the symbol. Works for all symbols
				headlines = false,
				-- or a table of tables that provide a name
				-- and (optional) highlight group for each headline level
				headlines = {
					{ "◉", "MyBulletL1" },
					{ "○", "MyBulletL2" },
					{ "✸", "MyBulletL3" },
					{ "✿", "MyBulletL4" },
				},
				checkboxes = {
					half = { "-", "@org.checkbox.halfchecked" },
					done = { "✓", "@org.keyword.done" },
					todo = { " ", "@org.keyword.todo" },
				},
			},
		},
	},
}
