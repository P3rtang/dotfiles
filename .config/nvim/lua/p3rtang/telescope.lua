require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "target"
        }
    },
  extensions = {
    -- fzf = {
    --   fuzzy = true,                    -- false will only do exact matching
    --   override_generic_sorter = false,  -- override the generic sorter
    --   override_file_sorter = true,     -- override the file sorter
    --   case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    -- },
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')
