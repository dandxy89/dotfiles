return {
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        enabled = true,
        cmd = "Copilot",
        event = "LspAttach",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = true,
        enabled = true,
        event = "LspAttach",
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "make tiktoken",
        opts = {},
    },
}
