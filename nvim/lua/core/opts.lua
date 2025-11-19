local opt = vim.opt

-- UI & Display
opt.guifont = 'JetBrains Mono'
opt.number, opt.relativenumber, opt.cursorline = true, true, true
opt.ruler, opt.laststatus, opt.cmdheight = false, 0, 1
opt.signcolumn, opt.numberwidth, opt.statuscolumn = 'yes:1', 3, '%l%s'
opt.pumheight, opt.winborder = 25, 'rounded'
opt.termguicolors, opt.background = true, 'dark'
opt.smoothscroll, opt.title = true, true

-- Files & Backup
opt.backup, opt.writebackup, opt.swapfile = false, false, false
opt.undofile, opt.undolevels = true, 10000
opt.autoread, opt.autowrite = true, true

-- Editing & Indentation
opt.encoding, opt.fileencoding = 'utf8', 'utf8'
opt.expandtab, opt.shiftwidth, opt.softtabstop, opt.tabstop = true, 4, 4, 4
opt.autoindent, opt.smartindent = true, true
opt.wrap = false

-- Search
opt.incsearch, opt.ignorecase, opt.smartcase = true, true, true

-- Splits & Windows
opt.splitright, opt.splitbelow = true, true
opt.scrolloff = 10

-- Completion & Popups
opt.completeopt = 'menu,menuone,noselect'

-- Timing
opt.ttimeoutlen, opt.timeoutlen, opt.updatetime = 0, 300, 200

-- Misc
opt.mouse, opt.clipboard = 'a', 'unnamedplus'
opt.belloff, opt.history = 'all', 50
opt.compatible, opt.spell, opt.spelllang = false, true, 'en_gb'
opt.shortmess = 'filnxtToOFWIcC'

-- Folding (treesitter-based)
opt.foldenable, opt.foldlevel, opt.foldcolumn = true, 99, '0'
opt.foldmethod, opt.foldexpr, opt.foldtext = 'expr', 'v:lua.vim.treesitter.foldexpr()', ''
opt.fillchars:append({ fold = ' ' })

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
vim.opt.diffopt:append('algorithm:histogram')

-- This is global settings for diagnostics
vim.filetype.add({
  pattern = { ['gitconf.*'] = 'gitconfig' },
})

-- Prevent LSP from overwriting treesitter colour settings
vim.hl.priorities.semantic_tokens = 95

-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.have_nerd_font = false
