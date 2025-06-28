---@type vim.lsp.Config
return {
    -- :!echo $VIRTUAL_ENV
    -- :!which python
    --
    -- [tool.basedpyright] # replace with pyright if using that
    -- exclude = [
    --   ".venv"
    -- ]
    -- venvPath = "."
    -- venv = ".venv"
    cmd = { "basedpyright" },
    filetypes = { "python" },
    root_markers = {
        ".git",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
    },
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                autoSearchPaths = true,
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "strict",
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = true,
                    functionReturnTypes = true,
                    genericTypes = false,
                },
            },
        },
    },
}
