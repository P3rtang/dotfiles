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
                ["q"] = "actions.close",
                ["<Esc>"] = "actions.close",

                ["<CR>"] = "actions.select",
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = { "actions.close", mode = "n" },
                ["<C-l>"] = "actions.refresh",

                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },

                ["g?"] = { "actions.show_help", mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",

                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
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
                desc = "Open parent directory",
            },
        },
    },
}
