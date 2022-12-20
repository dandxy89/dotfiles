local arr = { { "backup", false }, { "writebackup", false }, { "swapfile", false }, { "undofile", false },
    { "guifont", "Liga SFMono Nerd Font" }, { "colorcolumn", 100 }, { "number", true }, { "relativenumber", true },
    { "encoding", "utf8" }, { "fileencoding", "utf8" }, { "expandtab", true }, { "shiftwidth", 4 }, { "softtabstop", 4 },
    { "tabstop", 4 }, { "incsearch", true }, { "splitright", true }, { "splitbelow", true },
    { "autoindent", true }, { "smartindent", true }, { "autowrite", true }, { "termguicolors", true },
    { "ttimeoutlen", 0 }, { "timeoutlen", 300 }, { "signcolumn", "yes" }, { "updatetime", 50 }, { "wrap", false },
    { "completeopt", "menu,menuone,noselect" }, { "cmdheight", 0 }, { "autoread", true },
    { "shortmess", "filnxtToOFWIcC" }, { "mouse", "a" }, { "history", 200 } }
local api = vim.api
for k, v in pairs(arr) do
    api.nvim_set_option_value(v[1], v[2], {})
end

vim.api.nvim_command("colorscheme oxocarbon")

-- [[ AUTOCMD Removes unwanted trailing whitespace ]]
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    command = [[%s/\s\+$//e]]
})

-- [[ AUTOCMD Highlight yanked text ]]
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {
        clear = true
    }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            timeout = 300
        })
    end
})

-- [[ AUTOCMD Enable spell checking for certain file types ]]
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
        api.nvim_set_option_value("spell", true, {})
    end
})
