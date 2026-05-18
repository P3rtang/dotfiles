return {
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "zellij",
					enabled = true,
				},
			},
		},
		cli = {
			watch = true,
			win = {
				keys = {
					stopinsert = { "c-<esc>", "stopinsert", mode = "t" },
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
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
		name = "mcphub",
		event = "VeryLazy",
		opts = {
			config = vim.fn.expand("~/.config/mcphub/servers.json"),
			port = 37373, -- The port `mcp-hub` server listens to
			shutdown_delay = 5 * 60 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 5 minutes)
			use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
			mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks
			global_env = {}, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
			workspace = {
				enabled = true, -- Enable project-local configuration files
				look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
				reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
				port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
				get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
			},

			---Chat-plugin related options-----------------
			auto_approve = false, -- Auto approve mcp tool calls
			auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
			extensions = {
				avante = {
					make_slash_commands = true, -- make /slash commands from MCP server prompts
				},
			},

			--- Plugin specific options-------------------
			native_servers = {}, -- add your custom lua native servers here
			builtin_tools = {
				edit_file = {
					parser = {
						track_issues = true,
						extract_inline_content = true,
					},
					locator = {
						fuzzy_threshold = 0.8,
						enable_fuzzy_matching = true,
					},
					ui = {
						go_to_origin_on_complete = true,
						keybindings = {
							accept = ".",
							reject = ",",
							next = "n",
							prev = "p",
							accept_all = "ga",
							reject_all = "gr",
						},
					},
				},
			},
			ui = {
				window = {
					width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
					height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
					align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
					relative = "editor",
					zindex = 50,
					border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
				},
				wo = { -- window-scoped options (vim.wo)
					winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
				},
			},
			json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
			on_ready = function(hub)
				-- Called when hub is ready
			end,
			on_error = function(err)
				-- Called on errors
			end,
			log = {
				level = vim.log.levels.WARN,
				to_file = false,
				file_path = nil,
				prefix = "MCPHub",
			},
		},
	},
}
