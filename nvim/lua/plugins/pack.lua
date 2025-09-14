local pack_base = vim.fn.stdpath("data") .. "/site/pack/plugins"
local start_path = pack_base .. "/start"
local opt_path = pack_base .. "/opt"

vim.fn.mkdir(start_path, "p")
vim.fn.mkdir(opt_path, "p")

local plugins = {
    -- (always loaded)
    -- { url = "https://github.com/deparr/tairiki.nvim",                         name = "tairiki.nvim",                opt = false },
    { url = "https://github.com/dapovich/anysphere.nvim",                     name = "anysphere.nvim",              opt = false },
    { url = "https://github.com/nvim-lua/plenary.nvim",                       name = "plenary.nvim",                opt = false },
    { url = "https://github.com/folke/snacks.nvim",                           name = "snacks.nvim",                 opt = false },
    { url = "https://github.com/nvim-lualine/lualine.nvim",                   name = "lualine.nvim",                opt = false },
    { url = "https://github.com/ggandor/leap.nvim",                           name = "leap.nvim",                   opt = false },
    { url = "https://github.com/nvim-treesitter/nvim-treesitter",             name = "nvim-treesitter",             opt = false },
    { url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", name = "nvim-treesitter-textobjects", opt = false },
    { url = "https://github.com/williamboman/mason.nvim",                     name = "mason.nvim",                  opt = false },
    -- (lazy)
    { url = "https://github.com/ibhagwan/fzf-lua",                            name = "fzf-lua",                     opt = true, trigger = "command" },
    { url = "https://github.com/nvim-tree/nvim-web-devicons",                 name = "nvim-web-devicons",           opt = true, trigger = "file" },
    { url = "https://github.com/neovim/nvim-lspconfig",                       name = "nvim-lspconfig",              opt = true, trigger = "file" },
    { url = "https://github.com/williamboman/mason-lspconfig.nvim",           name = "mason-lspconfig.nvim",        opt = true, trigger = "file" },
    { url = "https://github.com/chrisgrieser/nvim-lsp-endhints",              name = "nvim-lsp-endhints",           opt = true, trigger = "lsp" },
    { url = "https://github.com/code-biscuits/nvim-biscuits",                 name = "nvim-biscuits",               opt = true, trigger = "file" },
    { url = "https://github.com/saghen/blink.cmp",                            name = "blink.cmp",                   opt = true, trigger = "insert",       build = "cargo build --release" },
    { url = "https://github.com/saghen/blink.pairs",                          name = "blink.pairs",                 opt = true, trigger = "insert",       build = "cargo build --release" },
    { url = "https://github.com/saghen/blink.indent",                         name = "blink.indent",                opt = true, trigger = "file" },
    { url = "https://github.com/mikavilpas/blink-ripgrep.nvim",               name = "blink-ripgrep.nvim",          opt = true, trigger = "insert" },
    { url = "https://github.com/ribru17/blink-cmp-spell",                     name = "blink-cmp-spell",             opt = true, trigger = "insert" },
    { url = "https://github.com/lewis6991/gitsigns.nvim",                     name = "gitsigns.nvim",               opt = true, trigger = "file" },
    { url = "https://github.com/nvim-pack/nvim-spectre",                      name = "nvim-spectre",                opt = true, trigger = "command" },
    { url = "https://github.com/christoomey/vim-tmux-navigator",              name = "vim-tmux-navigator",          opt = true, trigger = "keymap" },
    { url = "https://github.com/vim-test/vim-test",                           name = "vim-test",                    opt = true, trigger = "command" },
    { url = "https://github.com/preservim/vimux",                             name = "vimux",                       opt = true, trigger = "command" },
    { url = "https://github.com/vxpm/ferris.nvim",                            name = "ferris.nvim",                 opt = true, trigger = "filetype:rust" },
    { url = "https://github.com/Saecki/crates.nvim",                          name = "crates.nvim",                 opt = true, trigger = "cargo-toml" },
}

local JobManager = require("util.job_manager")

-- Parallel plugin installation
local function install_plugins_parallel(plugins_to_install, callback)
    if #plugins_to_install == 0 then
        if callback then callback() end
        return
    end

    JobManager:reset(callback)
    local build_queue = {}

    for _, plugin in ipairs(plugins_to_install) do
        local path = plugin.opt and opt_path or start_path
        local plugin_path = path .. "/" .. plugin.name

        print("Installing " .. plugin.name .. "...")

        local cmd = { "git", "clone", "--depth=1", plugin.url, plugin_path }

        JobManager:start_job(plugin, cmd, function(p, success)
            if success and p.build then
                table.insert(build_queue, p)
            end
        end)
    end

    -- Handle builds after all clones complete
    local original_callback = JobManager.callback
    JobManager.callback = function()
        if #build_queue > 0 then
            print("Starting build phase for " .. #build_queue .. " plugins...")
            JobManager:reset(original_callback)

            for _, plugin in ipairs(build_queue) do
                local path = plugin.opt and opt_path or start_path
                local plugin_path = path .. "/" .. plugin.name

                print("Building " .. plugin.name .. "...")
                local cmd = { "sh", "-c", "cd " .. vim.fn.shellescape(plugin_path) .. " && " .. plugin.build }
                JobManager:start_job(plugin, cmd)
            end
        else
            if original_callback then original_callback() end
        end
    end
end

-- Install missing plugins on startup
local function ensure_plugins_startup()
    local missing = {}

    for _, plugin in ipairs(plugins) do
        local path = plugin.opt and opt_path or start_path
        local plugin_path = path .. "/" .. plugin.name

        if not vim.loop.fs_stat(plugin_path) then
            table.insert(missing, plugin)
        end
    end

    if #missing > 0 then
        print("🚀 Installing " .. #missing .. " missing plugins in parallel...")
        install_plugins_parallel(missing, function()
            print("All plugins installed! Restart Neovim to apply changes.")
        end)
    end
end

ensure_plugins_startup()

-- Parallel update system
local function update_plugins_parallel()
    local existing_plugins = {}

    for _, plugin in ipairs(plugins) do
        local path = plugin.opt and opt_path or start_path
        local plugin_path = path .. "/" .. plugin.name

        if vim.fn.isdirectory(plugin_path) == 1 then
            table.insert(existing_plugins, plugin)
        end
    end

    if #existing_plugins == 0 then
        print("No plugins found to update!")
        return
    end

    print("🔄 Updating " .. #existing_plugins .. " plugins in parallel...")

    JobManager:reset(function()
        print("✅ All plugin updates completed! Restart Neovim to apply changes.")
    end)

    local build_queue = {}

    for _, plugin in ipairs(existing_plugins) do
        local path = plugin.opt and opt_path or start_path
        local plugin_path = path .. "/" .. plugin.name

        print("🔄 Updating " .. plugin.name .. "...")

        local cmd = { "sh", "-c",
            "cd " .. vim.fn.shellescape(plugin_path) ..
            " && git fetch --all" ..
            " && OLD=$(git rev-parse --short HEAD)" ..
            " && git pull --ff-only" ..
            " && NEW=$(git rev-parse --short HEAD)" ..
            " && if [ \"$OLD\" != \"$NEW\" ]; then" ..
            "   echo \"Updated: $OLD → $NEW\";" ..
            "   git log --oneline --no-decorate $OLD..$NEW;" ..
            " else" ..
            "   echo \"Already up-to-date at $OLD\";" ..
            " fi"
        }

        JobManager:start_job(plugin, cmd, function(p, success)
            if success and p.build then
                table.insert(build_queue, p)
            end
        end)
    end

    -- Handle builds after all updates complete
    local original_callback = JobManager.callback
    JobManager.callback = function()
        if #build_queue > 0 then
            print("🔨 Rebuilding " .. #build_queue .. " updated plugins...")
            JobManager:reset(original_callback)

            for _, plugin in ipairs(build_queue) do
                local path = plugin.opt and opt_path or start_path
                local plugin_path = path .. "/" .. plugin.name

                print("🔨 Building " .. plugin.name .. "...")
                local cmd = { "sh", "-c", "cd " .. vim.fn.shellescape(plugin_path) .. " && " .. plugin.build }
                JobManager:start_job(plugin, cmd)
            end
        else
            if original_callback then original_callback() end
        end
    end
end

-- Update command with parallel execution
vim.api.nvim_create_user_command("PackUpdate", function()
    update_plugins_parallel()
end, {})

vim.api.nvim_create_user_command("PackInstall", function()
    local missing = {}

    for _, plugin in ipairs(plugins) do
        local path = plugin.opt and opt_path or start_path
        local plugin_path = path .. "/" .. plugin.name

        if not vim.loop.fs_stat(plugin_path) then
            table.insert(missing, plugin)
        end
    end

    if #missing > 0 then
        print("Installing " .. #missing .. " missing plugins in parallel...")
        install_plugins_parallel(missing, function()
            print("Installed " .. #missing .. " plugins! Restart Neovim to apply changes.")
        end)
    else
        print("All " .. #plugins .. " plugins already installed!")
    end
end, {})

local function setup_lazy_loading()
    local loaded_groups = {}

    -- File-based triggers (treesitter, lsp)
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
        once = true,
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

    -- FzfLua command lazy-loading
    vim.api.nvim_create_user_command("FzfLua", function(opts)
        if not loaded_groups.command_fzf then
            loaded_groups.command_fzf = true
            vim.cmd("packadd fzf-lua")
            require("plugins.config.fzf")
        end
        -- Re-execute the command after loading
        vim.cmd("FzfLua " .. opts.args)
    end, { nargs = "+", complete = function() return {} end })

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

            vim.keymap.set('n', '<leader>fl', function()
                vim.cmd('write')
                vim.cmd('!cargo fmt')
                vim.cmd('edit')
            end, { desc = 'Save, format, and reload' })
        end
    })
end

-- Status command
vim.api.nvim_create_user_command("PackStatus", function()
    print("=== Core plugins (always loaded) ===")
    for _, plugin in ipairs(plugins) do
        if not plugin.opt then
            print("  " .. plugin.name)
        end
    end

    print("\n=== Lazy loaded plugins ===")
    local groups = {}
    for _, plugin in ipairs(plugins) do
        if plugin.opt then
            local trigger = plugin.trigger or "manual"
            if not groups[trigger] then
                groups[trigger] = {}
            end
            table.insert(groups[trigger], plugin)
        end
    end

    for trigger, group_plugins in pairs(groups) do
        print("\n  [" .. trigger .. "]")
        for _, plugin in ipairs(group_plugins) do
            local loaded = package.loaded[plugin.name:gsub("%.nvim$", "")] ~= nil
            print(string.format("    %s %s", loaded and "✓" or "○", plugin.name))
        end
    end
end, {})

vim.api.nvim_create_user_command("PackActive", function()
    local active_count = 0

    print("Core plugins:")
    for _, plugin in ipairs(plugins) do
        if not plugin.opt then
            active_count = active_count + 1
            print("  " .. plugin.name)
        end
    end

    local loaded_lazy = {}
    for _, plugin in ipairs(plugins) do
        if plugin.opt then
            local module_name = plugin.name:gsub("%.nvim$", ""):gsub("%-", "_")
            if package.loaded[module_name] or package.loaded[plugin.name:gsub("%.nvim$", "")] then
                active_count = active_count + 1
                table.insert(loaded_lazy, plugin)
            end
        end
    end

    if #loaded_lazy > 0 then
        print("\nLazy-loaded plugins (active):")
        for _, plugin in ipairs(loaded_lazy) do
            local trigger = plugin.trigger or "manual"
            print(string.format("  %s [%s]", plugin.name, trigger))
        end
    end

    print(string.format("Total active: %d/%d plugins", active_count, #plugins))

    if vim.fn.has('nvim-0.9') == 1 then
        local mem = vim.fn.luaeval('collectgarbage("count")')
        print(string.format("Lua memory: %.2f MB", mem / 1024))
    end
end, { desc = "Show currently active/loaded plugins" })

return {
    plugins = plugins,
    setup_lazy_loading = setup_lazy_loading,
}
