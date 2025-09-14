return {
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        enabled = false,
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
        enabled = false,
        event = "LspAttach",
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "make tiktoken",
        opts = {},
    },
}
