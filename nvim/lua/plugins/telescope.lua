return {
    {
        "ibhagwan/fzf-lua",
        lazy = true,
        event = "BufReadPost",
        opts = {
            fzf_opts = { ["--ansi"] = false },
        },
        config = function()
            require("fzf-lua").setup({
                grep = {
                    rg_glob = true,
                    glob_flag = "--iglob",
                    glob_separator = "%s%-%-",
                    rg_glob_fn = function(query, _)
                        local regex, flags = query:match("^(.-)%s%-%-(.*)$")
                        return (regex or query), flags
                    end,
                },
                previewers = {
                    builtin = {
                        syntax_limit_b = 1024 * 200, -- 200KB
                    },
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
                defaults = {
                    file_icons = "mini",
                    formatter = "path.filename_first",
                    path_shorten = 5,
                    git_icons = true,
                    color_icons = false,
                },
                lsp = {
                    code_actions = {
                        previewer = "codeaction_native",
                        preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
                    },
                },
            })
            require("fzf-lua").register_ui_select()
        end,
    },
    {
        "kelly-lin/ranger.nvim",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("ranger-nvim").setup({ replace_netrw = true })
            vim.api.nvim_set_keymap("n", "<leader>ef", "", {
                noremap = true,
                callback = function()
                    require("ranger-nvim").open(true)
                end,
            })
        end,
    },
}
