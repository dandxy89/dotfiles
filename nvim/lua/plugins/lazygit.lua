return {
    {
        "kdheepak/lazygit.nvim",
        keys = { "<leader>u" },
        ft = {
            "pest", "rust", "python", "lua", "ocamllsp",
            "dune", "javascript", "typescript",
            "typescriptreact", "typescript.tsx"
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
