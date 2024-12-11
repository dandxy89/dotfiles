---@diagnostic disable: undefined-global
local arr = {
	-- Brew install --cask font-geist-mono-nerd-font
	-- { "guifont", "GeistMono Nerd Font" },
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

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append("algorithm:histogram")

-- This is global settings for diagnostics
vim.o.updatetime = 250
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})
