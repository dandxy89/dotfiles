---@type vim.lsp.Config
return {
    filetypes = { "markdown", "text", "gitcommit", "mail" },
    root_markers = { ".git", "package.json", "Cargo.toml", "pyproject.toml" },
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.expand("~/.config/nvim/spell/harper-dict.txt"),
            codeActions = { ForceStable = false },
            markdown = { IgnoreLinkTitle = false },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "British",
        },
    },
}
