return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    keys = {
        { "<C-Space>", desc = "Increment Selection" },
        { "v",         desc = "Increment Selection", mode = "x" },
        { "V",         desc = "Shrink Selection",    mode = "x" },
    },
    opts = function()
        require("nvim-treesitter.configs").setup({
            ignore_install = { "" },
            auto_install = true,
            sync_install = true,
            ensure_installed = {
                "bash",
                "dockerfile",
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
                "sql",
                "toml",
                "typescript",
                "vim",
                "yaml",
            },
            highlight = {
                enable = true,
                use_lingua = false,
                current_word = true,
                additional_vim_regex_highlighting = false,
                use_languagetree = false,
                disable = function(_, bufnr)
                    local buf_name = vim.api.nvim_buf_get_name(bufnr)
                    local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
                    return file_size > 256 * 1024
                end,
            },
            ident = { enable = false },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
            matchup = { enable = true, include_match_words = true },
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
                    lookahead = true,
                    keymaps = {
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
                    set_jumps = true,
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
