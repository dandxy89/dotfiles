-- FZF-Lua setup (loaded lazily via plugins.manager.lazy)
local fzf_lua = require('fzf-lua')
fzf_lua.setup('default-title', {
  fzf_bin = 'fzf',
  defaults = { git_icons = false, file_icons = false },
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.35,
    col = 0.50,
    border = 'rounded',
    treesitter = false,
    preview = {
      default = 'bat',
      border = 'border',
      wrap = 'nowrap',
      hidden = 'nohidden',
      vertical = 'down:45%',
      horizontal = 'right:60%',
      layout = 'flex',
      flip_columns = 120,
    },
  },
  fzf_opts = {
    ['--cycle'] = true,
    ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-history',
    ['--history-size'] = '10000',
    ['--tiebreak'] = 'end',
  },
  files = {
    fd_opts = '--color=never --type f --hidden --follow --exclude .git',
    sort_lastused = true,
    fzf_opts = { ['--tiebreak'] = 'end' },
    actions = {
      ['ctrl-q'] = require('fzf-lua.actions').file_edit_or_qf,
    },
  },
  buffers = {
    sort_lastused = true,
    actions = {
      ['ctrl-q'] = require('fzf-lua.actions').file_edit_or_qf,
      ['ctrl-x'] = { fn = require('fzf-lua.actions').buf_del, reload = true },
    },
  },
  grep = {
    rg_opts = '--color=never --column --line-number --no-heading --smart-case --max-columns=4096 -e',
    actions = {
      ['ctrl-q'] = require('fzf-lua.actions').file_edit_or_qf,
      ['ctrl-g'] = require('fzf-lua.actions').grep_lgrep,
    },
  },
  lsp = { code_actions = { previewer = 'codeaction' } },
  manpages = { previewer = 'man_native' },
  helptags = { previewer = 'help_native' },
  tags = { previewer = 'bat' },
  btags = { previewer = 'bat' },
  keymap = {
    builtin = {
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
      ['<C-/>'] = 'toggle-preview',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-a'] = 'toggle-all',
      ['ctrl-d'] = 'preview-page-down',
      ['ctrl-u'] = 'preview-page-up',
      ['ctrl-/'] = 'toggle-preview',
    },
  },
})
fzf_lua.register_ui_select()
