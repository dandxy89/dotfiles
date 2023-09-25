return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- Can also be "auto" to detect automatically.
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                extensions = { "neo-tree", "lazy" },
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "VeryLazy",
        opts = {}
    },
}
