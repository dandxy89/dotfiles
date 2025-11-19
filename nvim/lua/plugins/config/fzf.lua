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

-- Keymap configuration: { key, command or function }
local keymaps = {
    { "<Leader><space>", "files" },
    { "<Leader>/", "live_grep" },
    { "<Leader>,", "buffers" },
    { "<Leader>ff", "files" },
    { "<Leader>fg", "git_files" },
    { "<Leader>fb", "buffers" },
    { "<Leader>fr", "oldfiles" },
    { "<Leader>sf", "resume" },
    { "<Leader>ss", "lsp_workspace_symbols" },
    { "<Leader>sd", "lsp_workspace_diagnostics" },
    { "<Leader>gs", "git_status" },
    { "<Leader>gl", "git_commits" },
    { "gd", "lsp_definitions" },
    { "gD", "lsp_declarations" },
    { "gr", "lsp_references" },
    { "gI", "lsp_implementations" },
    { "gy", "lsp_typedefs" },
    { "<Leader>ca", "lsp_code_actions" },
}

for _, map in ipairs(keymaps) do
    vim.keymap.set("n", map[1], "<cmd>FzfLua " .. map[2] .. "<cr>", opts)
end

-- Special keymap for config files
vim.keymap.set("n", "<Leader>fc", function()
    require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, opts)

