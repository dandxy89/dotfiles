-- Lazy loading setup for plugins
local M = {}

function M.setup_lazy_loading(plugins)
    local loaded_groups = {}

    -- File-based triggers (treesitter, lsp)
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
        callback = function()
            if loaded_groups.file then return end
            loaded_groups.file = true

            for _, plugin in ipairs(plugins) do
                if plugin.opt and plugin.trigger == "file" then
                    vim.cmd("packadd " .. plugin.name)
                end
            end

            -- Defer LSP/treesitter loading slightly to avoid blocking UI
            vim.defer_fn(function()
                require("plugins.config.treesitter")
                require("plugins.config.lsp")
                require("plugins.config.gitsigns")
            end, 10)
        end
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        once = true,
        callback = function()
            if loaded_groups.insert then return end
            loaded_groups.insert = true

            for _, plugin in ipairs(plugins) do
                if plugin.opt and plugin.trigger == "insert" then
                    vim.cmd("packadd " .. plugin.name)
                end
            end

            require("plugins.config.completion")
        end
    })

    -- LSP-based triggers (endhints)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
            if loaded_groups.lsp then return end
            loaded_groups.lsp = true

            for _, plugin in ipairs(plugins) do
                if plugin.opt and plugin.trigger == "lsp" then
                    vim.cmd("packadd " .. plugin.name)
                end
            end

            -- Setup lsp-endhints after it's loaded
            require("lsp-endhints").setup({})
        end
    })

    -- Cargo.toml specific trigger
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "Cargo.toml",
        once = true,
        callback = function()
            if loaded_groups["cargo-toml"] then return end
            loaded_groups["cargo-toml"] = true

            for _, plugin in ipairs(plugins) do
                if plugin.opt and plugin.trigger == "cargo-toml" then
                    vim.cmd("packadd " .. plugin.name)
                end
            end

            require("crates").setup()
        end
    })


    vim.api.nvim_create_user_command("Spectre", function()
        vim.cmd("packadd nvim-spectre")
        require("plugins.config.spectre")
        require("spectre").open()
    end, {})

    vim.api.nvim_create_user_command("TestNearest", function()
        vim.cmd("packadd vim-test")
        vim.cmd("packadd vimux")
        vim.cmd("TestNearest")
    end, {})

    vim.api.nvim_create_user_command("TestFile", function()
        vim.cmd("packadd vim-test")
        vim.cmd("packadd vimux")
        vim.cmd("TestFile")
    end, {})

    for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
        vim.keymap.set("n", key, function()
            if not loaded_groups.keymap then
                loaded_groups.keymap = true
                vim.cmd("packadd vim-tmux-navigator")
                require("plugins.config.tmux")
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
        end, { desc = "Tmux navigate" })
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        once = true,
        callback = function()
            vim.cmd("packadd ferris.nvim")

            local keymap = vim.keymap.set
            keymap("n", "<Leader>ml", ':lua require("ferris.methods.view_memory_layout")()<CR>')
            keymap("n", "<Leader>em", ':lua require("ferris.methods.expand_macro")()<CR>')
            keymap("n", "<Leader>od", ':lua require("ferris.methods.open_documentation")()<CR>')

            
        end
    })
end

return M
