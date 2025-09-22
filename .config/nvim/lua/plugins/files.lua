return {
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true,
			delete_to_trash = false,
			columns = { "icon", "permissions", "size", "mtime" },
			view_options = {
				show_hidden = true,
			},
			git = {
				-- Return true to automatically git add/mv/rm files
				add = function()
					return false
				end,
				mv = function()
					return true
				end,
				rm = function()
					return false
				end,
			},
			float = {
				-- Padding around the floating window
				padding = 8,
				-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				max_width = 0.64,
				max_height = 0.80,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
				get_win_title = nil,
				-- preview_split: Split direction: "auto", "left", "right", "above", "below".
				preview_split = "right",
			},
			keymaps = {
				["q"] = { "actions.close", desc = "Oil: Close" },
				["<Esc>"] = { "actions.close", desc = "Oil: Close" },

				["<CR>"] = { "actions.select", desc = "Oil: Select" },
				["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Oil: Select and split vertical" },
				["<C-h>"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Oil: Select and split horizontal",
				},
				["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Oil: Select and open in new tab" },
				["<C-p>"] = { "actions.preview", desc = "Oil: Toggle buffer preview" },
				["<C-l>"] = "actions.refresh",
				["<C-c>"] = { "actions.close", mode = "n", desc = "Oil: Close" },

				["-"] = { "actions.parent", mode = "n", desc = "Oil: go to parent directory" },
				["_"] = { "actions.open_cwd", mode = "n", desc = "Oil: open cwd (root directory)" },
				["`"] = { "actions.cd", mode = "n", desc = "Oil: change directory" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n", desc = "Oil: set temp cwd" },

				["g?"] = { "actions.show_help", mode = "n", desc = "Oil: show help" },
				["gs"] = { "actions.change_sort", mode = "n", desc = "Oil: change sorting" },
				["gx"] = { "actions.open_external", desc = "Oil: open external file" },

				["g."] = { "actions.toggle_hidden", mode = "n", desc = "Oil: toggle hidden files" },
				["g\\"] = { "actions.toggle_trash", mode = "n", desc = "Oil: toggle show trash" },
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = false,
		},
		keys = {
			{
				"-",
				function()
					require("oil").open_float(nil, { preview = { vertical = true } })
				end,
				desc = "Oil: open parent directory",
			},
		},
	},
}
