return {
    cmd = { "ruff-lsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml" },
    settings = {
        ["ruff-lsp"] = {
            format = {
                args = {},
            },
        },
    },
}
