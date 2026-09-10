local opt = vim.opt

opt.guifont = 'JetBrains Mono'
opt.number, opt.relativenumber, opt.cursorline = true, true, true
opt.ruler, opt.laststatus, opt.cmdheight = false, 2, 1
opt.signcolumn, opt.numberwidth, opt.statuscolumn = 'yes:1', 3, '%l%s'
opt.pumheight, opt.winborder = 25, 'rounded'
opt.background = 'dark'
opt.smoothscroll, opt.title = true, true
opt.guicursor = {
  'n-v:block',
  'i-c-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}

opt.backup, opt.writebackup, opt.swapfile = false, false, false
opt.undofile, opt.undolevels = true, 10000
opt.autoread, opt.autowrite = true, true

opt.expandtab, opt.shiftwidth, opt.softtabstop, opt.tabstop = true, 4, 4, 4
opt.smartindent = true
opt.wrap = false

opt.ignorecase, opt.smartcase = true, true

opt.splitright, opt.splitbelow = true, true
opt.scrolloff = 10

opt.ttimeoutlen, opt.timeoutlen, opt.updatetime = 0, 300, 200

opt.clipboard = 'unnamedplus'
opt.spelllang = 'en_gb'
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.defer_fn(function()
      vim.o.spell = true
    end, 50)
  end,
})
opt.shortmess = 'filnxtToOFWcC'

opt.foldenable, opt.foldlevel, opt.foldcolumn = true, 99, '0'
opt.foldmethod, opt.foldexpr, opt.foldtext = 'expr', 'v:lua.vim.treesitter.foldexpr()', ''
opt.fillchars:append({ fold = ' ' })

opt.diffopt:append('algorithm:histogram')

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
