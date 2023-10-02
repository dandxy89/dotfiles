--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Vim Options                        ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local arr = {
    { "backup",         false },
    { "writebackup",    false },
    { "swapfile",       false },
    { "undofile",       false },
    -- { "guifont", "Liga SFMono Nerd Font" },
    { "guifont",        "JetBrains Mono NL" },
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
    { "signcolumn",     "yes" },
    { "updatetime",     200 },
    { "wrap",           false },
    { "completeopt",    "menu,menuone,noselect" },
    { "autoread",       true },
    { "belloff",        "all" },
    { "shortmess",      "filnxtToOFWIcC" },
    { "mouse",          "a" },
    { "history",        1000 },
    { "title",          true },
    { "spelllang",      "en" },
    { "guicursor",      "a:blinkon200" },
    { "laststatus",     3 },
    { "clipboard",      "unnamedplus" },
    { "background",     "dark" },
    { "compatible",     false },
    -- { "compatible", false },
}

for _, v in pairs(arr) do
    vim.api.nvim_set_option_value(v[1], v[2], {})
end
