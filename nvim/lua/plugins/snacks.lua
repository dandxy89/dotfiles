return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.80,
                    row = 0.35,
                    col = 0.50,
                    border = "rounded",
                    preview = {
                        default = "bat",
                        border = "border",
                        wrap = "nowrap",
                        hidden = "nohidden",
                        vertical = "down:45%",
                        horizontal = "right:60%",
                        layout = "flex",
                        flip_columns = 120,
                    },
                },
                fzf_opts = {
                    ["--cycle"] = true,
                    ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
                    ["--history-size"] = "10000"
                },
                files = {
                    cmd = "fd --type f --hidden --follow --exclude .git"

                },
                live_grep = {
                    rg_opts = "--hidden --follow --smart-case --column --glob '!.git/*'",
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
            })
        end,
        keys = {
            { "<Leader><space>", "<cmd>FzfLua combine pickers=files;grep_project<cr>",                        desc = "Find Files or Grep" },
            { "<Leader>fc",      function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<Leader>sf",      "<cmd>FzfLua resume<cr>",                                                    desc = "Resume Last Search" },
            { "<Leader>/",       "<cmd>FzfLua live_grep<cr>",                                                 desc = "Live Grep" },

            { "gd",              "<cmd>FzfLua lsp_definitions<cr>",                                           desc = "LSP Definitions" },
            { "gD",              "<cmd>FzfLua lsp_declarations<cr>",                                          desc = "LSP Declarations" },
            { "gr",              "<cmd>FzfLua lsp_references<cr>",                                            desc = "LSP References" },
            { "gI",              "<cmd>FzfLua lsp_implementations<cr>",                                       desc = "LSP Implementations" },
            { "gy",              "<cmd>FzfLua lsp_typedefs<cr>",                                              desc = "LSP Type Definitions" },

            { "<Leader>ca",      "<cmd>FzfLua lsp_code_actions<cr>",                                          desc = "Code Actions" },
            { "<Leader>sd",      "<cmd>FzfLua lsp_workspace_diagnostics<cr>",                                 desc = "Document Diagnostics" },

            { "<Leader>ss",      "<cmd>FzfLua lsp_workspace_symbols<cr>",                                     desc = "LSP Workspace Symbols" },

            { "<Leader>,",       "<cmd>FzfLua buffers<cr>",                                                   desc = "Buffers" },
            { "<Leader>:",       "<cmd>FzfLua command_history<cr>",                                           desc = "Command History" },
            { "<Leader>fb",      "<cmd>FzfLua buffers<cr>",                                                   desc = "Buffers" },
            { "<Leader>ff",      "<cmd>FzfLua files<cr>",                                                     desc = "Find Files" },
            { "<Leader>fg",      "<cmd>FzfLua git_files<cr>",                                                 desc = "Find Git Files" },
            { "<Leader>fr",      "<cmd>FzfLua oldfiles<cr>",                                                  desc = "Recent Files" },
            { "<Leader>gl",      "<cmd>FzfLua git_commits<cr>",                                               desc = "Git Log" },
            { "<Leader>gs",      "<cmd>FzfLua git_status<cr>",                                                desc = "Git Status" },
            { "<Leader>sb",      "<cmd>FzfLua blines<cr>",                                                    desc = "Buffer Lines" },
            { "<Leader>sB",      "<cmd>FzfLua grep_curbuf<cr>",                                               desc = "Grep Current Buffer" },
            { "<Leader>sw",      "<cmd>FzfLua grep_cword<cr>",                                                desc = "Grep Word Under Cursor" },
            { "<Leader>s\"",     "<cmd>FzfLua registers<cr>",                                                 desc = "Registers" },
            { "<Leader>s/",      "<cmd>FzfLua search_history<cr>",                                            desc = "Search History" },
            { "<Leader>sc",      "<cmd>FzfLua command_history<cr>",                                           desc = "Command History" },
            { "<Leader>sC",      "<cmd>FzfLua commands<cr>",                                                  desc = "Commands" },
            { "<Leader>sh",      "<cmd>FzfLua help_tags<cr>",                                                 desc = "Help Tags" },
            { "<Leader>sH",      "<cmd>FzfLua highlights<cr>",                                                desc = "Highlights" },
            { "<Leader>sj",      "<cmd>FzfLua jumps<cr>",                                                     desc = "Jumps" },
            { "<Leader>sk",      "<cmd>FzfLua keymaps<cr>",                                                   desc = "Keymaps" },
            { "<Leader>sl",      "<cmd>FzfLua loclist<cr>",                                                   desc = "Location List" },
            { "<Leader>sm",      "<cmd>FzfLua marks<cr>",                                                     desc = "Marks" },
            { "<Leader>sM",      "<cmd>FzfLua manpages<cr>",                                                  desc = "Man Pages" },
            { "<Leader>sq",      "<cmd>FzfLua quickfix<cr>",                                                  desc = "Quickfix List" },
            { "<Leader>uC",      "<cmd>FzfLua colorschemes<cr>",                                              desc = "Colorschemes" },
        },
    },
    {
        "folke/flash.nvim",
        lazy = true,
        event = "LspAttach",
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
            },
        },
        specs = {
            {
                "folke/snacks.nvim",
                ---@type snacks.Config
                opts = {
                    picker = {
                        win = {
                            input = {
                                keys = {
                                    ["<a-s>"] = { "flash", mode = { "n", "i" } },
                                    ["s"] = { "flash" },
                                },
                            },
                        },
                        actions = {
                            flash = function(picker)
                                require("flash").jump({
                                    pattern = "^",
                                    label = { after = { 0, 0 } },
                                    search = {
                                        mode = "search",
                                        exclude = {
                                            function(win)
                                                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                                                    ~= "snacks_picker_list"
                                            end,
                                        },
                                    },
                                    action = function(match)
                                        local idx = picker.list:row2idx(match.pos[1])
                                        picker.list:_move(idx, true, true)
                                    end,
                                })
                            end,
                        },
                    },
                },
            },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            animate = { enabled = false },
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            debug = { enabled = false },
            dim = { enabled = false },
            explorer = { enabled = true, replace_netrw = true },
            indent = { enabled = false },
            input = { enabled = false },
            notifier = {
                enabled = true,
                timeout = 1000,
                win = { backdrop = { transparent = false } },
            },
            picker = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            {
                "<Leader>e",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            {
                "<Leader>gB",
                function()
                    Snacks.gitbrowse()
                end,
                desc = "Git Browse",
            },
            {
                "<Leader>gb",
                function()
                    Snacks.git.blame_line()
                end,
                desc = "Git Blame Line",
            },
            {
                "<Leader>gf",
                function()
                    Snacks.lazygit.log_file()
                end,
                desc = "Lazygit Current File History",
            },
            {
                "<Leader>lg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
            {
                "<Leader>gl",
                function()
                    Snacks.lazygit.log()
                end,
                desc = "Lazygit Log (cwd)",
            },
            {
                "<Leader>n",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "Notification History",
            },
            {
                "<Leader>d",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Delete Buffer",
            },
            {
                "<Leader>un",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Dismiss All Notifications",
            },
            {
                "<Leader>.",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Terminal",
            },
        },
        init = function()
            vim.g.snacks_animate = false
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<Leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<Leader>uL")
                    Snacks.toggle.line_number():map("<Leader>ul")
                    Snacks.toggle
                        .option("conceallevel", {
                            off = 0,
                            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
                        })
                        :map("<Leader>uc")
                    Snacks.toggle.inlay_hints():map("<Leader>uh")
                    Snacks.toggle.indent():map("<Leader>ug")
                    Snacks.toggle.dim():map("<Leader>uD")
                end,
            })
        end,
    },
}
