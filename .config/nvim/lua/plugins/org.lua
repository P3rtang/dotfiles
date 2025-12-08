return {
	{
		"nvim-orgmode/orgmode",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/orgfiles/**/*",
				org_default_notes_file = "~/orgfiles/refile.org",
				org_todo_keywords = { "TODO(t)", "NEXT(n)", "PROG(p)", "INTR(i)", "|", "DONE(d)", "DELG(g)" },
				org_todo_keyword_faces = {
					PROG = ":foreground cyan",
					NEXT = ":foreground orange :weight bold",
					DELG = ":slant italic",
				},
				mappings = {
					org = {
						org_todo = "<M-t>",
						org_todo_prev = "<M-T>",
					},
				},
				win_split_mode = { "float", 0.6 },
				org_startup_folded = "content",
			})
		end,
	},
	{
		"nvim-orgmode/org-bullets.nvim",
		config = function()
			require("org-bullets").setup({
				concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
				symbols = {
					-- list symbol
					list = "•",
					-- headlines can be a list
					headlines = { "◉", "○", "✸", "✿" },
					-- or a function that receives the defaults and returns a list
					-- headlines = function(default_list)
					-- 	table.insert(default_list, "♥")
					-- 	return default_list
					-- end,
					-- or false to disable the symbol. Works for all symbols
					-- headlines = false,
					-- or a table of tables that provide a name
					-- and (optional) highlight group for each headline level
					-- headlines = {
					-- 	{ "◉", "MyBulletL1" },
					-- 	{ "○", "MyBulletL2" },
					-- 	{ "✸", "MyBulletL3" },
					-- 	{ "✿", "MyBulletL4" },
					-- },
					checkboxes = {
						half = { "-", "@org.checkbox.halfchecked" },
						done = { "✓", "@org.keyword.done" },
						todo = { " ", "@org.keyword.todo" },
					},
				},
			})
		end,
	},
}
