local arr = {
    { "guifont",        "Iosevka Term" },
    { "backup",         false },
    { "writebackup",    false },
    { "swapfile",       false },
    { "undofile",       true },
    { "ruler",          false },
    { "number",         true },
    { "relativenumber", true },
    { "encoding",       "utf8" },
    { "fileencoding",   "utf8" },
    { "expandtab",      true },
    { "shiftwidth",     4 },
    { "softtabstop",    4 },
    { "tabstop",        4 },
    { "incsearch",      true },
    { "splitright",     true },
    { "splitbelow",     true },
    { "autoindent",     true },
    { "smartindent",    true },
    { "autowrite",      true },
    { "termguicolors",  true },
    { "ttimeoutlen",    0 },
    { "timeoutlen",     300 },
    { "wrap",           false },
    { "completeopt",    "menu,menuone,noselect" },
    { "autoread",       true },
    { "belloff",        "all" },
    { "mouse",          "a" },
    { "history",        50 },
    { "title",          true },
    { "spell",          true },
    { "smoothscroll",   true },
    { "spelllang",      "en_gb" },
    { "background",     "dark" },
    { "compatible",     false },
    { "scrolloff",      10 },
    { "updatetime",     50 },
    { "signcolumn",     "yes:1" },
    { "pumheight",      25 },
    { "numberwidth",    3 },
    { "statuscolumn",   "%l%s" },
    { "cmdheight",      1 },
    { "laststatus",     0 },
    { "winborder",      "rounded" },
    { "clipboard",      "unnamedplus" },
}

vim.keymap.set("n", "<leader>ll", function()
    vim.cmd.match(string.format("Visual /%s/", vim.fn.expand("<cword>")))
end, { desc = "highlight another word" })

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

for _, v in pairs(arr) do
    vim.api.nvim_set_option_value(v[1], v[2], {})
end

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append("algorithm:histogram")

-- This is global settings for diagnostics
vim.filetype.add({
    filename = { [".env"] = "config" },
    pattern = { ["gitconf.*"] = "gitconfig" },
})

-- Prevent LSP from overwriting treesitter colour settings
vim.hl.priorities.semantic_tokens = 95
