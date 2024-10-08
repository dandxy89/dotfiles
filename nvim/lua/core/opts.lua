---@diagnostic disable: undefined-global
local arr = {
    -- Brew install --cask font-geist-mono-nerd-font
	{ "guifont", "GeistMono Nerd Font" },
	{ "backup", false },
	{ "writebackup", false },
	{ "swapfile", false },
	{ "undofile", false },
	{ "number", true },
	{ "relativenumber", true },
	{ "encoding", "utf8" },
	{ "encoding", "utf8" },
	{ "fileencoding", "utf8" },
	{ "expandtab", true },
	{ "shiftwidth", 4 },
	{ "softtabstop", 4 },
	{ "tabstop", 4 },
	{ "incsearch", true },
	{ "splitright", true },
	{ "splitbelow", true },
	{ "autoindent", true },
	{ "smartindent", true },
	{ "autowrite", true },
	{ "termguicolors", true },
	{ "ttimeoutlen", 0 },
	{ "timeoutlen", 300 },
	{ "signcolumn", "yes" },
	{ "wrap", false },
	{ "completeopt", "menu,menuone,noselect" },
	{ "autoread", true },
	{ "belloff", "all" },
	{ "mouse", "a" },
	{ "history", 50 },
	{ "title", true },
	{ "spell", true },
	{ "spelllang", "en_gb" },
	{ "laststatus", 3 },
	{ "background", "dark" },
	{ "compatible", false },
	{ "scrolloff", 10 },
	{ "updatetime", 50 },
	{ "signcolumn", "yes:1" },
	{ "pumheight", 25 },
}

for _, v in pairs(arr) do
	vim.api.nvim_set_option_value(v[1], v[2], {})
end

-- Cursor shape
vim.opt.guicursor = {
    "n-v-c:block",                                  -- Normal, visual, command-line: block cursor
    "i-ci-ve:ver25",                                -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
    "r-cr:hor20",                                   -- Replace, command-line replace: horizontal bar cursor with 20% height
    "o:hor50",                                      -- Operator-pending: horizontal bar cursor with 50% height
    "a:blinkwait700-blinkoff400-blinkon250",        -- All modes: blinking settings
    "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append('algorithm:histogram')
