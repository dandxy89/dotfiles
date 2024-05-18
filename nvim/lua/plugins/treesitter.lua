--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Treesitter                         ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects"
            },
            {
                'andymass/vim-matchup',
            },
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = function()
                    require("treesitter-context").setup({
                        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                        line_numbers = true,
                        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                        trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                        mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
                        -- Separator between context and content. Should be a single character string, like '-'.
                        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                        separator = nil,
                        zindex = 20,     -- The Z-index of the context window
                        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
                        throttle = true, -- Throttles plugin updates (may improve performance)
                        max_lines = 3,   -- How many lines the window should span. Values <= 0 mean no limit.
                    })
                end,
            },
        },
        opts = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                auto_install = false,
                sync_install = false,
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "dockerfile",
                    "hcl",
                    "http",
                    "javascript",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "proto",
                    "python",
                    "regex",
                    "rust",
                    "toml",
                    "vim",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    use_languagetree = false,
                    disable = function(_, bufnr)
                        local buf_name = vim.api.nvim_buf_get_name(bufnr)
                        local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
                        return file_size > 256 * 1024
                    end,
                },
                ident = {
                    enable = true,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
                matchup = {
                    enable = true,             -- mandatory, false will disable the whole extension
                    disable = { "c", "ruby" }, -- optional, list of language that will be disabled
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["at"] = "@comment.outer",
                        },
                        include_surrounding_whitespace = true,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    }
}
