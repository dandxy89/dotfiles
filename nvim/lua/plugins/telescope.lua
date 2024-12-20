return {
    {
        "ibhagwan/fzf-lua",
        lazy = true,
        event = "BufReadPost",
        opts = {
            fzf_opts = {
                ["--ansi"] = false,
                ["--no-scrollbar"] = true,
            },
        },
        cmd = "FzfLua",
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "fzf-lua" } })
                require("fzf-lua").register_ui_select()
                return vim.ui.select(...)
            end
        end,
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
                    builtin = { true, ["<Esc>"] = "hide" },
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
                defaults = {
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
        enabled = false,
        lazy = true,
        event = "VeryLazy",
        opts = function()
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
