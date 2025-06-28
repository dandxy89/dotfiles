---@type vim.lsp.Config
return {
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
                allFeatures = true,
                buildScripts = { enable = true },
                loadOutDirsFromCheck = true,
            },
            diagnostics = { enable = true },
            inlayHints = {
                enable = true,
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = "never" },
                lifetimeElisionHints = {
                    enable = "never",
                    useParameterNames = false,
                },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = "never" },
                renderColons = true,
                typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                },
            },
            lens = {
                enable = true,
                methodReferences = true,
                references = true,
                implementations = false,
            },
            interpret = { tests = true },
            procMacro = {
                enable = true,
                ignored = { leptos_macro = { "component", "server" } },
            },
        },
    },
}
