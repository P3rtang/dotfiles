return {
    {
        "nvim-orgmode/orgmode",
        version = "0.7.1",
        opts = {
            org_agenda_files = {'~/orgfiles/**/*'},
            org_default_notes_file = '~/orgfiles/refile.org',
            org_id_method = 'org',
            org_id_link_to_org_use_id = true,
            org_todo_keywords = {'TODO(t)', 'NEXT(n)', 'PROG(p)', '|', 'REVW(r)', 'DONE(d)', 'DELG(g)'},
            mappings = {
                org = {
                    org_insert_heading_respect_content = '<C-h>',
                    org_toggle_checkbox = '<C-c>',
                }
            },
        }
    },
    {
        "nvim-orgmode/org-bullets.nvim",
        event = 'VeryLazy',
        dependencies = { "orgmode" },
        opts = {
            concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
            symbols = {
                -- list symbol
                list = "•",
                -- headlines can be a list
                headlines = { "◉", "○", "✸", "✿" },
                -- or a function that receives the defaults and returns a list
                headlines = function(default_list)
                    table.insert(default_list, "♥")
                    return default_list
                end,
                -- or false to disable the symbol. Works for all symbols
                headlines = false,
                -- or a table of tables that provide a name
                -- and (optional) highlight group for each headline level
                headlines = { 
                    { "◉", "MyBulletL1" },
                    { "○", "MyBulletL2" },
                    { "✸", "MyBulletL3" },
                    { "✿", "MyBulletL4" },
                },
                checkboxes = {
                    half = { "-", "@org.checkbox.halfchecked" },
                    done = { "✓", "@org.keyword.done" },
                    todo = { " ", "@org.keyword.todo" },
                },
            }
        }
    }
}
