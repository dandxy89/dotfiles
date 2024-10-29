---@diagnostic disable: undefined-global
return {

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = true,
        event = "BufReadPost",
        config = function()
            require("fzf-lua").setup({
                fzf_opts = { ["--wrap"] = true },
                grep = { rg_glob = true },
                winopts = {
                    preview = {
                        wrap = "wrap",
                    },
                },
                defaults = {
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                    formatter = "path.filename_first",
                },
            })
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
