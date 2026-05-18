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
	local buf = vim.api.nvim_create_buf(false, true) -- create a scratch buffer
	local win = vim.api.nvim_get_current_win()
	-- get height and width
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

	vim.fn.jobstart("make", {
		term = true,
		on_exit = function()
			-- When "make" finishes, process its output
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

			-- Use errorformat to parse the lines into the quickfix list
			vim.fn.setqflist({}, "r", { title = "Make Errors", lines = lines })

			-- Open the quickfix window
			vim.cmd.copen()

			-- Close the terminal buffer
			vim.api.nvim_win_close(term_buf, true)

			-- Put the quickfix window at the right
			vim.cmd.wincmd("H")
			vim.api.nvim_win_set_width(0, 80)
		end,
	})
end, { noremap = true })
