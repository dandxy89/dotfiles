-- [[ vars.lua ]]
local g = vim.g
g.t_co = 256
g.pairing_mode = false
g.degraded_mode = false
g.background = "dark"

-- [[ opts.lua ]]
local opt = vim.opt

-- -- [[ Context ]]
opt.colorcolumn = '100' -- str:  Show col for max line length
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 8 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column
opt.smartindent = true

-- -- [[ Filetypes ]]
opt.encoding = 'utf8' -- str:  String encoding to use
opt.fileencoding = 'utf8' -- str:  File encoding to use

-- -- [[ Theme ]]
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable
vim.o.background = "dark"

-- -- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for

-- -- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- -- [[ Custom ]]
opt.guifont = "jetbrains-mono-nerd-font" -- str: brew tap homebrew/cask-fonts && brew install jet_brains_mono_nerd_font
opt.updatetime = 100 -- num: faster completion
opt.wrap = false -- bool: display lines as one long line
opt.completeopt = {"menu", "menuone", "noselect"}
opt.title = true -- bool: set the title of window to the value of the titlestring
opt.autoread = true -- bool: Deal with file loads after updating via git etc
vim.o.autoread = true -- bool: auto-reload files when modified externally
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
vim.wo.signcolumn = "yes"

vim.cmd [[set clipboard+=unnamedplus]]
vim.cmd [[set ttyfast]] -- Speed up scrolling in Vim
vim.cmd [[set timeoutlen=350]]

-- -- [[ Scrolling ]]
vim.o.cursorline = false
opt.scrolloff = 100
opt.synmaxcol = 100
opt.mouse = 'a'

-- -- [[ Theme ]]
vim.cmd [[colorscheme gruvbox]]

-- -- [[ Spelling On ]]
vim.cmd [[set spell spelllang=en_gb]]

-- -- [[ vim-test config ]]
vim.cmd [[let test#strategy = "neovim"]]

-- [[ AUTOCMD Removes unwanted trailing whitespace ]]
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*"},
    command = [[%s/\s\+$//e]]
})

-- -- [[ AUTOCMD Highlight yanked text ]]
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

-- -- [[ NeoTree ]]
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
