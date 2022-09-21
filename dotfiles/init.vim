filetype on
let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')

Plug 'lewis6991/spellsitter.nvim'
Plug 'itchyny/lightline.vim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'numToStr/Comment.nvim'

" Git
Plug 'mhinz/vim-signify'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'weilbith/nvim-code-action-menu'
Plug 'kosayoda/nvim-lightbulb'

" LSP Completion
Plug 'Shougo/deoplete.nvim'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'

" Navigation
Plug 'karb94/neoscroll.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'andymass/vim-matchup'
Plug 'm-demare/hlargs.nvim'
Plug 'voldikss/vim-floaterm'

"" Rust
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'saecki/crates.nvim'
Plug 'folke/trouble.nvim'

call plug#end()

syntax on
set encoding=utf-8
set wildmode=longest,list,full
set wildmenu
set number relativenumber
set nu rnu
set termguicolors
set cmdheight=2
set ignorecase
set smartcase
set incsearch
set visualbell
set expandtab
set tabstop=4
set ruler
set smartindent
set shiftwidth=4
set autoindent
set scrolloff=7
set splitright
set splitbelow
set encoding=UTF-8
set updatetime=100


" Colors
set colorcolumn=80
set guifont=JetBrains\ Mono  " brew tap homebrew/cask-fonts && brew install --cask font-JetBrains-Mono
colorscheme gruvbox-baby
set background=dark
set showtabline=2  " always show tabline
let g:gruvbox_termcolors=16

" NERDTree
let g:NERDDefaultAlign = 'left'
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:rustfmt_autosave = 1 " Rust

" deoplete -> poetry run pip install pynvim
let g:deoplete#enable_at_startup = 1

autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
let g:code_action_menu_window_border = 'single'

" Configure LSP code navigation shortcuts
nnoremap <silent> D         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gc        <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> R         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gn        <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs        <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gw        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> L         <cmd>lua vim.diagnostic.show()<CR>

" FloaTerm configuration
nnoremap <leader>ft         <cmd>FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 <CR>

" Replaced LSP implementation with code action plugin...
nnoremap <silent> A         <cmd>CodeActionMenu<CR>

" Trouble
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>

" Shortcuts
map <leader>n :NERDTreeToggle<CR>
map <leader>, :bprevious<CR>
nnoremap <leader>f <cmd>FZF<cr>
nnoremap <F11> :tabprevious<CR>

" Harpoon
nnoremap <F7>  :lua require("harpoon.mark").add_file()<CR>
nnoremap <F8>  :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <F9>  :lua require("harpoon.ui").nav_next()<CR>

" The Primagen Recommendation
nnoremap <leader>t <cmd>"\_dP"<CR>

" Configure Rust LSP.
lua <<EOF
local cmp = require'cmp'

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require'lspconfig'
cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- Tab immediately completes. C-n/C-p to select.
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },
})

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
} 
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

require('Comment').setup()
require('crates').setup()

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash", "c", "cmake", "css", 
    "dockerfile", "go", "gomod", "gowork", 
    "hcl", "help", "html", "http", 
    "javascript", "json", "lua", "make", 
    "markdown", "python", "regex", "ruby", 
    "rust", "toml", "vim", "yaml", "zig"
  },
  auto_install = true,
  highlight = {
    enable = true,
  },
  ident = { 
    enable = true
  }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}
require('hlargs').setup()
require('neoscroll').setup()

local rt = {
    capabilities = capabilities,
    server = {
        settings = {
            ["rust-analyzer"] = {
                assist = {
                  importEnforceGranularity = true,
                  importPrefix = "crate"
                },
                cargo = {
                    allFeatures = true
                },
                checkOnSave = {
                    -- default: `cargo clippy`
                    command = "clippy"
                },
                inlayHints = {
                  lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true
                  },
                },
            },
        }
    },
}

require('rust-tools').setup(rt)
require("trouble").setup()

-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

EOF
