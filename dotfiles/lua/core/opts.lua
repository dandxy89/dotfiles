-- [[ vars.lua ]]
local g = vim.g
g.t_co = 256
g.pairing_mode = false
g.degraded_mode = false

-- -- [[ opts.lua ]]
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-- -- -- [[ Theme ]]
-- opt.background = "dark"
vim.cmd.colorscheme "oxocarbon"

-- -- https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized
opt.guifont = "Liga SFMono Nerd Font"

-- -- -- [[ Context ]]
opt.colorcolumn = '100' -- str:  Show col for max line length
opt.number = true -- bool: Show line numbers
-- opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 10 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column
opt.smartindent = true
opt.history = 30
-- opt.wildignore = "*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"

-- -- -- [[ Filetypes ]]
opt.encoding = 'utf8' -- str:  String encoding to use
opt.fileencoding = 'utf8' -- str:  File encoding to use

-- -- -- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for

opt.hlsearch = false
opt.incsearch = true

-- -- -- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- -- -- [[ Custom ]]
vim.o.autoread = true -- bool: auto-reload files when modified externally

opt.clipboard = 'unnamedplus'

opt.autoindent = true
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen = 0
opt.timeoutlen = 400
opt.signcolumn = 'yes'

-- opt.redrawtime = 100
opt.updatetime = 50 -- num: faster completion

opt.wrap = false -- bool: display lines as one long line
opt.completeopt = {"menu", "menuone", "noselect"}

opt.title = true -- bool: set the title of window to the value of the titlestring

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = false

opt.showmatch = true
opt.ttyfast = true -- Speed up scrolling in Vim
vim.wo.signcolumn = "yes"

-- -- -- [[ Scrolling ]]
vim.o.cursorline = false
opt.scrolloff = 15
opt.synmaxcol = 35
opt.mouse = 'a'

-- -- [[ AUTOCMD Removes unwanted trailing whitespace ]]
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*"},
    command = [[%s/\s\+$//e]]
})

-- -- -- [[ AUTOCMD Highlight yanked text ]]
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

-- -- -- [[ vim-test config ]]
vim.cmd [[let test#strategy = "neovim"]]
