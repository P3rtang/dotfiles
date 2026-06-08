return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio", -- Required layout dependency for modern nvim-dap-ui
		"leoluz/nvim-dap-go", -- Specialized helper for seamless Go/Delve integration
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Initialize peripheral UI modules
		dapui.setup()
		require("nvim-dap-virtual-text").setup()
		require("dap-go").setup() -- Automatically configs Delve debugging targets

		----------------------------------------------------------------
		-- KEYMAPS: Ergonomic Debugging Shortcuts
		----------------------------------------------------------------
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Start/Continue Session" })
		vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
		vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step Over" })
		vim.keymap.set("n", "<leader>dx", dap.step_out, { desc = "DAP: Step Out" })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL Stream" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI Sidebars" })

		----------------------------------------------------------------
		-- AUTO-UI HOOKS: Control Sidebars on Session Lifecycle Events
		----------------------------------------------------------------
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.after.event_initialized.dapui_config = function()
			dapui.open()
		end
		dap.listeners.after.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.after.event_exited.dapui_config = function()
			dapui.close()
		end

		----------------------------------------------------------------
		-- ADAPTERS & CONFIGS: Native Configurations for Rust and Zig
		----------------------------------------------------------------
		-- We use CodeLLDB as the underlying runner engine for Rust and Zig binaries
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				-- Adjust this path if your lldb executor binary binary lives elsewhere
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		-- Rust Configuration mapping
		dap.configurations.rust = {
			{
				name = "Launch Rust Executable",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
				end,
				cwd = "${workspaceRoot}",
				stopOnEntry = false,
			},
		}

		-- Zig Configuration mapping (shares the LLDB compilation engine)
		dap.configurations.zig = {
			{
				name = "Launch Zig Executable",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
				end,
				cwd = "${workspaceRoot}",
				stopOnEntry = false,
			},
		}
	end,
}
