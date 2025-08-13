return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = {
		-- add any opts here
		-- for example
		provider = "copilot",
		providers = {
			ollama = {
				endpoint = "http://192.168.0.58:11434",
				model = "gemma3:4b",
				disabled_tools = {
					"attempt_completion",
					"read_definitions",
				},
			},
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "gpt-4o-2024-05-13",
				proxy = nil,
				allow_insecure = false,
				timeout = 30000,
			},
		},
		auto_suggestions_provider = "copilot",
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			cmd = "Copilot",
			build = ":Copilot auth",
			opts = {
				panel = { enabled = false },
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<M-l>", -- Alt+l to accept
						accept_word = "<M-w>", -- Alt+w to accept word
						accept_line = "<M-j>", -- Alt+j to accept line
						next = "<M-]>", -- Alt+] for next suggestion
						prev = "<M-[>", -- Alt+[ for previous suggestion
						dismiss = "<C-]>", -- Ctrl+] to dismiss
					},
				},
				filetypes = {
					yaml = false,
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			},
		},

		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		web_search_engine = {
			enable = true, -- true or false
			provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
			proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
		},
	},
}
