-- make + quickfix
-- TODO: move this to separate onBufEnter functions
vim.opt.errorformat = {
    -- rust
    "%Eerror[E%n]: %m,%Z%.%#--> %f:%l:%c",
    "%Wwarning: %m,%Z%.%#--> %f:%l:%c",
    "%.%#--> %f:%l:%c",

    -- zig
    "%f:%l:%c: error: %m",

    -- ignore if file is in zig std lib
    "%-C%.%#packages%.%#",
    "%-G%.%#packages%.%#",

    -- zig file in test output
    "%Z%f:%l:%c: %.%#",

    "%f:%l:%c: %.%#",


    "%E%.%# panic: %m",

    -- info
    "%f:%l:%c: [%tNFO] %m",
    "%f:%l: [%tNFO] %m",
}

vim.opt.makeprg = "make"

local function open_term ()
    vim.cmd.new()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)

    return vim.bo.channel
end

vim.keymap.set('n', '<leader>tm', open_term, { noremap = true })

vim.keymap.set('n', '<leader>mm', function ()
    local channel = open_term()
    vim.fn.chansend(channel, 'make\n')
end)
