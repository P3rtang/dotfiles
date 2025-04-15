return {
    {
        "folke/todo-comments.nvim",
        dependencies = 'nvim-lua/plenary.nvim',
        opts = {},
        init = function ()
            require("todo-comments").setup()
        end
    }
}
