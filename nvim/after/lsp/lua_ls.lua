---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            completion = {
                enable = true,
                callSnippet = "Replace",
                keywordSnippet = "Replace",
            },
            diagnostics = {
                enable = true,
                globals = {
                    "vim",
                    "require",
                    "use",
                    "love",
                    "Snacks",
                    "LazyVim",
                    "MiniPick",
                    "MiniExtra",
                },
                -- Enable more comprehensive diagnostics
                neededFileStatus = {
                    ["codestyle-check"] = "Any",
                },
                groupSeverity = {
                    strong = "Warning",
                    strict = "Warning",
                },
                groupFileStatus = {
                    ["ambiguity"] = "Opened",
                    ["await"] = "Opened",
                    ["codestyle"] = "None",
                    ["duplicate"] = "Opened",
                    ["global"] = "Opened",
                    ["luadoc"] = "Opened",
                    ["redefined"] = "Opened",
                    ["strict"] = "Opened",
                    ["strong"] = "Opened",
                    ["type-check"] = "Opened",
                    ["unbalanced"] = "Opened",
                    ["unused"] = "Opened",
                },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    -- Add Neovim runtime paths for better type checking
                    vim.fn.stdpath("config"),
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                },
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            semantic = {
                enable = true,
            },
            type = {
                castNumberToInteger = true,
                weakUnionCheck = true,
                weakNilCheck = true,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                },
            },
            hint = {
                enable = true,
                arrayIndex = "Auto",
                await = true,
                paramName = "All",
                paramType = true,
                semicolon = "SameLine",
                setType = false,
            },
        },
    },
}
