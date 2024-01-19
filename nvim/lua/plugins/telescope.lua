--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Telescope                          ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        cmd = "Telescope",
        event = "BufReadPre",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build =
                'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
            { "SalOrak/whaler" },
        },
        opts = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')
            -- Custom keymaps
            vim.keymap.set("n", "<Leader>fw", function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end, { desc = "Search for word under cursor" })
            vim.keymap.set("n", "<Leader>few", function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end, { desc = "Search for the exact word under cursor" })
            -- Setup
            telescope.setup({
                -- Previews
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                -- Pickers
                pickers = {
                    lsp_references = {
                        show_line = true,
                    },
                },
                -- Extensions
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or 'ignore_case' or 'respect_case'
                    },
                    whaler = {
                        -- Whaler configuration
                        directories = {
                            "/Users/sigma-dan/Sigma",
                            "/Users/sigma-dan/.config/",
                            "/Users/sigma-dan/Dan"
                        },
                        auto_file_explorer = false, -- Do not open file explorer
                        auto_cwd = true,            -- But change working directory
                    }
                },
            })
            -- Load extensions
            telescope.load_extension("fzf")
            telescope.load_extension("whaler")
            telescope.load_extension("noice")
        end,
    },
}
