local o = vim.o

o.number = true
o.relativenumber = true
o.cursorline = true
o.ruler = false
o.laststatus = 2
o.cmdheight = 1
o.signcolumn = 'yes:1'
o.numberwidth = 3
o.statuscolumn = '%l%s'
o.pumheight = 25
o.winborder = 'rounded'
o.background = 'dark'
o.smoothscroll = true
o.title = true
o.guicursor = table.concat({
  'n-v:block',
  'i-c-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}, ',')

o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true
o.undolevels = 10000
o.autoread = true
o.autowrite = true

o.expandtab = true
o.shiftwidth = 4
o.softtabstop = 4
o.tabstop = 4
o.wrap = false

o.ignorecase = true
o.smartcase = true

o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'
o.jumpoptions = 'view'
o.confirm = true
o.breakindent = true
o.inccommand = 'split'
o.scrolloff = 10

o.ttimeoutlen = 0
o.timeoutlen = 300
o.updatetime = 200

o.clipboard = 'unnamedplus'
-- headless/SSH boxes without xclip/xsel/wl-clipboard: fall back to OSC52 instead of warning on every yank
if vim.env.SSH_TTY and vim.fn.has('clipboard') == 0 then
  vim.g.clipboard = 'osc52'
end
o.spelllang = 'en_gb'
-- spell is enabled per filetype in ftplugin/{markdown,text,gitcommit}.lua; Harper covers code comments
o.shortmess = 'filnxtToOFWcC'

o.foldenable = true
o.foldlevel = 99
o.foldcolumn = '0'
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldtext = ''
vim.opt.fillchars:append({ fold = ' ' })

vim.opt.diffopt:append('algorithm:histogram')

vim.filetype.add({
  filename = { ['.env'] = 'dosini' },
  pattern = {
    ['%.env%..*'] = 'dosini',
    ['gitconf.*'] = 'gitconfig',
    ['.*[cC]ompose%.ya?ml'] = 'yaml.docker-compose',
  },
})

vim.hl.priorities.semantic_tokens = 95

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
