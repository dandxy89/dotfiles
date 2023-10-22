--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Vim Options                        ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local arr = {
    -- FONT
    -- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/JetBrainsMono.zip
    -- { "guifont",        "JetBrainsMono Nerd Font" },
    -- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/GeistMono.zip
    { "guifont",        "GeistMono NF" },
    --
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
    { "clipboard",      "unnamedplus" },
    { "background",     "dark" },
    { "compatible",     false },
    { "scrolloff",      8 },
    { "spell",          true },
    -- { "updatetime",     50 },
}

for _, v in pairs(arr) do
    vim.api.nvim_set_option_value(v[1], v[2], {})
end
