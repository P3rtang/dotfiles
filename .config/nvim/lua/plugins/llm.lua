return {
	{
		"folke/sidekick.nvim",
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
            nes = { enabled = false },
			auto_suggestions_provider = "copilot",
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
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
			"ravitemer/mcphub.nvim", -- for custom_tools function
		-- 	{
		-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
		-- 		cmd = "Copilot",
		-- 		build = ":Copilot auth",
		-- 		opts = {
		-- 			panel = { enabled = false },
		-- 			suggestion = {
		-- 				enabled = true,
		-- 				auto_trigger = true,
		-- 				debounce = 75,
		-- 				keymap = {
		-- 					accept = "<M-l>", -- Alt+l to accept
		-- 					accept_word = "<M-w>", -- Alt+w to accept word
		-- 					accept_line = "<M-j>", -- Alt+j to accept line
		-- 					next = "<M-]>", -- Alt+] for next suggestion
		-- 					prev = "<M-[>", -- Alt+[ for previous suggestion
		-- 					dismiss = "<C-]>", -- Ctrl+] to dismiss
		-- 				},
		-- 			},
		-- 			filetypes = {
		-- 				yaml = false,
		-- 				markdown = true,
		-- 				help = false,
		-- 				gitcommit = false,
		-- 				gitrebase = false,
		-- 				hgcommit = false,
		-- 				svn = false,
		-- 				cvs = false,
		-- 				["."] = false,
		-- 			},
		-- 		},
		-- 	},
		-- },

		keys = {
			-- {
			-- 	"<tab>",
			-- 	function()
			-- 		-- if there is a next edit, jump to it, otherwise apply it if any
			-- 		if not require("sidekick").nes_jump_or_apply() then
			-- 			return "<Tab>" -- fallback to normal tab
			-- 		end
			-- 	end,
			-- 	expr = true,
			-- 	desc = "Goto/Apply Next Edit Suggestion",
			-- },
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus()
				end,
				desc = "Sidekick Focus",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Never set this value to "*"! Never!
	-- 	opts = {
	-- 		-- add any opts here
	-- 		-- for example
	-- 		provider = "gemini",
	-- 		providers = {
	-- 			ollama = {
	-- 				endpoint = "http://192.168.0.58:11434",
	-- 				model = "gemma3:12b-it-qat",
	-- 				extra_request_body = {
	-- 					stream = true,
	-- 				},
	-- 			},
	-- 			copilot = {
	-- 				endpoint = "https://api.githubcopilot.com",
	-- 				model = "gpt-4.1-2025-04-14",
	-- 				proxy = nil,
	-- 				allow_insecure = false,
	-- 				timeout = 30000,
	-- 			},
	-- 			gemini = {
	-- 				endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
	-- 				model = "gemini-3-flash-preview",
	-- 				timeout = 30000, -- Timeout in milliseconds
	-- 				context_window = 1048576,
	-- 				use_ReAct_prompt = true,
	-- 				extra_request_body = {
	-- 					generationConfig = {
	-- 						temperature = 0.75,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 		auto_suggestions_provider = "copilot",
	-- 		behaviour = {
	-- 			auto_approve_tool_permissions = {
	-- 				"ls",
	-- 				"glob",
	-- 				"grep",
	-- 				"read_definitions",
	-- 				"get_diagnostics",
	-- 			},
	-- 			confirmation_ui_style = "popup",
	-- 		},
	-- 		mode = "legacy",
	-- 		disabled_tools = {
	-- 			"view",
	-- 			"write_to_file",
	-- 			"str_replace",
	-- 			"insert",
	-- 			"add_todos",
	-- 			"update_todo_status",
	-- 		},
	-- 		use_react_prompt = true,
	-- 		system_prompt = function()
	-- 			local hub = require("mcphub").get_hub_instance()
	-- 			return hub and hub:get_active_servers_prompt() or ""
	-- 		end,
	-- 		-- Using function prevents requiring mcphub before it's loaded
	-- 		custom_tools = function()
	-- 			return {
	-- 				require("mcphub.extensions.avante").mcp_tool(),
	-- 			}
	-- 		end,
	-- 		web_search_engine = {
	-- 			provider = "brave",
	-- 		},
	-- 	},
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	build = "make",
	-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		--- The below dependencies are optional,
	-- 		"echasnovski/mini.pick", -- for file_selector provider mini.pick
	-- 		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	-- 		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
	-- 		"ibhagwan/fzf-lua", -- for file_selector provider fzf
	-- 		"stevearc/dressing.nvim", -- for input provider dressing
	-- 		"folke/snacks.nvim", -- for input provider snacks
	-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	-- 		"ravitemer/mcphub.nvim",
	-- 		{
	-- 			"zbirenbaum/copilot.lua", -- for providers='copilot'
	-- 			cmd = "Copilot",
	-- 			build = ":Copilot auth",
	-- 			opts = {
	-- 				panel = { enabled = false },
	-- 				suggestion = {
	-- 					enabled = true,
	-- 					auto_trigger = false,
	-- 					debounce = 0,
	-- 					keymap = {
	-- 						accept = "<M-l>", -- Alt+l to accept
	-- 						accept_word = "<M-w>", -- Alt+w to accept word
	-- 						accept_line = "<M-j>", -- Alt+j to accept line
	-- 						next = "<M-]>", -- Alt+] for next suggestion
	-- 						prev = "<M-[>", -- Alt+[ for previous suggestion
	-- 						dismiss = "<C-]>", -- Ctrl+] to dismiss
	-- 					},
	-- 				},
	-- 				filetypes = {
	-- 					yaml = false,
	-- 					markdown = true,
	-- 					help = false,
	-- 					gitcommit = false,
	-- 					gitrebase = false,
	-- 					hgcommit = false,
	-- 					svn = false,
	-- 					cvs = false,
	-- 					["."] = false,
	-- 				},
	-- 			},
	-- 		},
	--
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 			opts = {
	-- 				-- recommended settings
	-- 				default = {
	-- 					embed_image_as_base64 = false,
	-- 					prompt_for_file_name = false,
	-- 					drag_and_drop = {
	-- 						insert_mode = true,
	-- 					},
	-- 					-- required for Windows users
	-- 					use_absolute_path = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		{
	-- 			-- Make sure to set this up properly if you have lazy=true
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				file_types = { "markdown", "Avante" },
	-- 			},
	-- 			ft = { "markdown", "Avante" },
	-- 		},
	-- 		web_search_engine = {
	-- 			enable = true, -- true or false
	-- 			provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
	-- 			proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
	-- 		},
	-- 	},
	-- },
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end,
	},
}
