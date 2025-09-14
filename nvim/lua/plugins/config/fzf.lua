-- FZF-Lua setup
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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader><space>", "<cmd>FzfLua files<cr>", opts)
vim.keymap.set("n", "<Leader>/", "<cmd>FzfLua live_grep<cr>", opts)
vim.keymap.set("n", "<Leader>,", "<cmd>FzfLua buffers<cr>", opts)
vim.keymap.set("n", "<Leader>ff", "<cmd>FzfLua files<cr>", opts)
vim.keymap.set("n", "<Leader>fg", "<cmd>FzfLua git_files<cr>", opts)
vim.keymap.set("n", "<Leader>fb", "<cmd>FzfLua buffers<cr>", opts)
vim.keymap.set("n", "<Leader>fr", "<cmd>FzfLua oldfiles<cr>", opts)
vim.keymap.set("n", "<Leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, opts)
vim.keymap.set("n", "<Leader>sf", "<cmd>FzfLua resume<cr>", opts)
vim.keymap.set("n", "<Leader>ss", "<cmd>FzfLua lsp_workspace_symbols<cr>", opts)
vim.keymap.set("n", "<Leader>sd", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", opts)

vim.keymap.set("n", "<Leader>gs", "<cmd>FzfLua git_status<cr>", opts)
vim.keymap.set("n", "<Leader>gl", "<cmd>FzfLua git_commits<cr>", opts)

vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", opts)
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", opts)
vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", opts)
vim.keymap.set("n", "<Leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", opts)

