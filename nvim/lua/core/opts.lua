-- Basic settings
vim.opt.guifont = "Iosevka Term"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true -- Enable persistent undo
vim.opt.ruler = false
vim.opt.compatible = false

-- Display settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:1"
vim.opt.pumheight = 25
vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%l%s"
vim.opt.cmdheight = 0
vim.opt.laststatus = 0 -- Disable global statusline
vim.opt.wrap = false
vim.opt.smoothscroll = true
vim.opt.scrolloff = 10
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Encoding settings
vim.opt.encoding = "utf8"
vim.opt.fileencoding = "utf8"

-- Editing settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.autowrite = true
vim.opt.autoread = true

-- Search settings
vim.opt.incsearch = true
vim.opt.completeopt = "menu,menuone,noselect"

-- Split settings
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Timing settings
vim.opt.ttimeoutlen = 0
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250 -- Consistent with LSP setting below

-- Interface settings
vim.opt.belloff = "all"
vim.opt.mouse = "a"
vim.opt.history = 50

-- Spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_gb"

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append("algorithm:histogram")

-- Global diagnostic settings
vim.filetype.add({
    filename = { [".env"] = "config" },
    pattern = { ["gitconf.*"] = "gitconfig" },
})
