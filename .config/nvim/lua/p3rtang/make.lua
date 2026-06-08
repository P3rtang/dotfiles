-- make + quickfix
-- TODO: move this to separate onBufEnter functions
-- vim.opt.errorformat = {
-- 	-- rust
-- 	"%Eerror[E%n]: %m,%Z%.%#--> %f:%l:%c",
-- 	"%Wwarning: %m,%Z%.%#--> %f:%l:%c",
-- 	"%.%#--> %f:%l:%c",
--
-- 	-- zig
-- 	"%f:%l:%c: error: %m",
--
-- 	-- ignore if file is in zig std lib
-- 	"%-C%.%#packages%.%#",
-- 	"%-G%.%#packages%.%#",
--
-- 	-- zig file in test output
-- 	"%Z%f:%l:%c: %.%#",
--
-- 	"%f:%l:%c: %.%#",
--
-- 	"%E%.%# panic: %m",
--
-- 	-- info
-- 	"%f:%l:%c: [%tNFO] %m",
-- 	"%f:%l: [%tNFO] %m",
-- }

vim.opt.makeprg = "make"

vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Load Go errorformat globally if inside a Go module workspace",
	callback = function()
		-- Native Vim function searches upward for go.mod starting from current file directory
		if vim.fn.findfile("go.mod", vim.fn.expand("%:p:h") .. ";") ~= "" then
			vim.opt.errorformat = {
				"%f:%l:%c:%m",
				"%f:%l:%m",
				"    %f:%l: %m",
				"%-G%.%#",
			}
		end
	end,
})

local function open_term()
	vim.cmd.new()
	vim.cmd.edit("term://make")
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)

	return vim.bo.channel
end

vim.keymap.set("n", "<leader>tm", open_term, { noremap = true })

vim.keymap.set("n", "<leader>mm", function()
	local channel = open_term()
	vim.fn.chansend(channel, "make\n")
end)

-- move to quickfix window if there are errors close the terminal window
vim.keymap.set("n", "<leader>mq", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_get_current_win()
	local height = vim.api.nvim_win_get_height(win)
	local width = vim.api.nvim_win_get_width(win)

	local term_buf = vim.api.nvim_open_win(buf, true, {
		relative = "win",
		width = 80,
		height = 10,
		col = (width - 80) / 2,
		row = (height - 10) / 2,
		border = "single",
	})

	local raw_lines = {}

	vim.fn.jobstart("make", {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					raw_lines[#raw_lines + 1] = line:gsub("\r", "")
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					raw_lines[#raw_lines + 1] = line:gsub("\r", "")
				end
			end
		end,
		on_exit = function()
			vim.api.nvim_win_close(term_buf, true)

			local current_package_dir = ""
			local final_lines = {}

			-- 1. First pass: Scan backward to resolve and inject the missing package directories
			for i = #raw_lines, 1, -1 do
				local line = raw_lines[i]

				local pkg = line:match("^FAIL%s+github%.com/p3rtang/org%-mcp/([%w%-_/]+)")
				if pkg then
					current_package_dir = pkg .. "/"
				end

				-- Fix: Match any .go file that starts with indentation/whitespace (typical of go test outputs)
				if current_package_dir ~= "" and line:match("^%s+[%w%-_]+%.go:") then
					-- Only inject if the directory isn't already prefixed in the line
					if not line:find(current_package_dir, 1, true) then
						line = line:gsub("^%s+", "    " .. current_package_dir)
					end
				end

				table.insert(final_lines, 1, line)
			end

			-- 2. Second pass: Split into two distinct Quickfix list entries
			local qf_items = {}
			for _, line in ipairs(final_lines) do
				local file, lnum, msg = line:match("^%s*([%w%-_/%.]+%.go):(%d+):%s*(.*)$")

				if file and lnum then
					-- Row 1: The jumpable file target
					table.insert(qf_items, {
						filename = file,
						lnum = tonumber(lnum),
						text = "↳ Error found here:",
						type = "E",
					})
					-- Row 2: The actual error text on the literal next line
					if msg ~= "" then
						table.insert(qf_items, {
							text = "    " .. msg,
							type = "I", -- Informational so it doesn't try to open a file
						})
					end
				else
					table.insert(qf_items, {
						text = line,
						type = "I",
					})
				end
			end

			-- Safely deliver our custom-built entry schema directly to the Quickfix view
			vim.fn.setqflist({}, "r", {
				title = "Make Errors",
				items = qf_items,
			})

			if not vim.tbl_isempty(vim.fn.getqflist()) then
				vim.cmd("copen")
				vim.cmd("wincmd H")
				vim.api.nvim_win_set_width(0, 80)
			else
				print("🎒 All build and test pipelines passed cleanly!")
			end
		end,
	})
end, { noremap = true })
