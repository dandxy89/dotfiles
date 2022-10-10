--[[ opts.lua ]]
local opt = vim.opt

-- [[ Context ]]
opt.colorcolumn = '80'           -- str:  Show col for max line length
opt.number = true                -- bool: Show line numbers
opt.relativenumber = true        -- bool: Show relative line numbers
opt.scrolloff = 4                -- int:  Min num lines of context
opt.signcolumn = "yes"           -- str:  Show the sign column

-- [[ Filetypes ]]
opt.encoding = 'utf8'            -- str:  String encoding to use
opt.fileencoding = 'utf8'        -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = false             -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true             -- bool: Use spaces instead of tabs
opt.shiftwidth = 4               -- num:  Size of an indent
opt.softtabstop = 4              -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4                  -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one

-- [[ Custom ]]
opt.guifont = "JetBrains Mono"   -- str: brew tap homebrew/cask-fonts && brew install --cask font-JetBrains-Mono
opt.updatetime = 80 			 -- num: faster completion
opt.wrap = false 				 -- bool: display lines as one long line
opt.completeopt = { "menuone", "noselect" }
opt.title = true				 -- bool: set the title of window to the value of the titlestring
opt.completeopt = "menu,menuone,noselect"
opt.autoread = true				 -- bool: Deal with file loads after updating via git etc
vim.o.autoread = true			 -- bool: auto-reload files when modified externally

vim.cmd[[colorscheme gruvbox-baby]]
vim.cmd[[set spell]]			 -- Using the Built in Spell Checker
vim.cmd[[set splitbelow]]
vim.cmd[[set splitright]]
vim.cmd[[set scrolloff=999]]