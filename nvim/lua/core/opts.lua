--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Vim Options                        ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local arr = {
    -- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/GeistMono.zip
    { "guifont",        "GeistMono NF" },
    -- NVIM settings
    { "backup",         false },
    { "writebackup",    false },
    { "swapfile",       false },
    { "undofile",       false },
    { "number",         true },
    { "relativenumber", true },
    { "encoding",       "utf8" },
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
    { "signcolumn",     "yes" },
    { "wrap",           false },
    { "completeopt",    "menu,menuone,noselect" },
    { "autoread",       true },
    { "belloff",        "all" },
    { "shortmess",      "filnxtToOFWIcC" },
    { "mouse",          "a" },
    { "history",        50 },
    { "title",          true },
    { "spelllang",      "en_gb" },
    { "laststatus",     3 },
    { "background",     "dark" },
    { "compatible",     false },
    { "scrolloff",      8 },
    { "spell",          true },
    { "spell",          true },
    { "updatetime",     300 },
    { "signcolumn",     "yes:1" },
}

for _, v in pairs(arr) do
    vim.api.nvim_set_option_value(v[1], v[2], {})
end

-- Cursor shape
vim.opt.gcr = {
    'i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor',
    'n-v:block-Curosr/lCursor',
    'o:hor50-Curosr/lCursor',
    'r-cr:hor20-Curosr/lCursor',
}

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append('algorithm:histogram')
