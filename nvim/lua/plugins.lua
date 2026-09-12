---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'blink-cmp' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.cmd.packadd('blink-lib')
      vim.cmd.packadd('blink-cmp')
      require('blink.cmp').download():pwait()
    end
  end,
})

vim.pack.add({
  gh('zitrocode/carvion.nvim'),
  { src = gh('saghen/blink.cmp'), name = 'blink-cmp', version = vim.version.range('*') },
  { src = gh('saghen/blink.lib'), name = 'blink-lib' },
  gh('mikavilpas/blink-ripgrep.nvim'),
  { src = 'https://codeberg.org/andyg/leap.nvim.git', name = 'leap.nvim' },
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
}, { confirm = false })

vim.pack.add({
  gh('lewis6991/gitsigns.nvim'),
  gh('ibhagwan/fzf-lua'),
}, { load = function() end, confirm = false })

---@param name string
---@param setup fun()
---@return fun()
local function lazy(name, setup)
  local done = false
  return function()
    if not done then
      done = true
      vim.cmd.packadd(name)
      setup()
    end
  end
end

vim.cmd.colorscheme('carvion')

require('blink.cmp').setup({
  completion = {
    keyword = { range = 'prefix' },
    ghost_text = { enabled = true },
    list = { selection = { preselect = false, auto_insert = true } },
    menu = { auto_show = true, border = 'rounded', draw = { treesitter = { 'lsp' } } },
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
      treesitter_highlighting = true,
      auto_show_delay_ms = 150,
    },
    trigger = { show_on_insert_on_trigger_character = true },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  keymap = { preset = 'enter' },
  signature = { enabled = true, window = { border = 'rounded' } },
  cmdline = { enabled = true, sources = { default = { 'cmdline', 'path' } } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'ripgrep' },
    providers = {
      ripgrep = { module = 'blink-ripgrep', name = 'Ripgrep', min_keyword_length = 3 },
      lsp = { name = 'LSP', module = 'blink.cmp.sources.lsp', min_keyword_length = 0 },
    },
  },
})

vim.g.treesitter_parsers = {
  'bash',
  'lua',
  'rust',
  'python',
  'typescript',
  'javascript',
  'json',
  'yaml',
  'toml',
  'markdown',
  'vim',
  'proto',
  'make',
  'dockerfile',
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom_treesitter', { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].bigfile or not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  once = true,
  callback = function()
    require('nvim-treesitter-textobjects').setup({
      select = { lookahead = true, include_surrounding_whitespace = true },
      move = { set_jumps = true },
    })
    local select = require('nvim-treesitter-textobjects.select')
    for lhs, query in pairs({
      aa = '@parameter.outer',
      ia = '@parameter.inner',
      af = '@function.outer',
      ['if'] = '@function.inner',
      ac = '@class.outer',
      ic = '@class.inner',
      ai = '@conditional.outer',
      ii = '@conditional.inner',
      al = '@loop.outer',
      il = '@loop.inner',
      at = '@comment.outer',
    }) do
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(query, 'textobjects')
      end)
    end
    local move = require('nvim-treesitter-textobjects.move')
    for lhs, m in pairs({
      [']m'] = { 'goto_next_start', '@function.outer' },
      [']]'] = { 'goto_next_start', '@class.outer' },
      [']M'] = { 'goto_next_end', '@function.outer' },
      [']['] = { 'goto_next_end', '@class.outer' },
      ['[m'] = { 'goto_previous_start', '@function.outer' },
      ['[['] = { 'goto_previous_start', '@class.outer' },
      ['[M'] = { 'goto_previous_end', '@function.outer' },
      ['[]'] = { 'goto_previous_end', '@class.outer' },
    }) do
      vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
        move[m[1]](m[2], 'textobjects')
      end)
    end
  end,
})

local sel_node, sel_buf ---@type TSNode?, integer?
---@param node TSNode
local function select_node(node)
  local sr, sc, er, ec = node:range()
  if ec == 0 then
    er = er - 1
    ec = #vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1]
  end
  vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
  vim.api.nvim_buf_set_mark(0, '>', er + 1, math.max(ec - 1, 0), {})
  vim.cmd('normal! gv')
end
vim.keymap.set('n', '<C-space>', function()
  sel_node, sel_buf = vim.treesitter.get_node(), vim.api.nvim_get_current_buf()
  if sel_node then
    select_node(sel_node)
  end
end, { desc = 'Init treesitter selection' })
---@param next fun(node: TSNode): TSNode?
---@return fun()
local function step(next)
  return function()
    if not sel_node or sel_buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    local node = next(sel_node)
    if node then
      sel_node = node
      select_node(node)
    end
  end
end
vim.keymap.set(
  'x',
  '<C-space>',
  step(function(n)
    return n:parent()
  end),
  { desc = 'Expand treesitter selection' }
)
vim.keymap.set(
  'x',
  '<BS>',
  step(function(n)
    return n:named_child(0)
  end),
  { desc = 'Shrink treesitter selection' }
)

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = lazy('gitsigns.nvim', function()
    require('gitsigns').setup({
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs string|fun()
        ---@param desc string
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        ---@param direction 'next'|'prev'
        ---@return fun()
        local function nav_hunk(direction)
          return function()
            if vim.wo.diff then
              vim.cmd.normal({ direction == 'next' and ']c' or '[c', bang = true })
            else
              gs.nav_hunk(direction)
            end
          end
        end
        map('n', ']h', nav_hunk('next'), 'Next hunk')
        map('n', '[h', nav_hunk('prev'), 'Previous hunk')
        map('n', '<Leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<Leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<Leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<Leader>hR', gs.reset_buffer, 'Reset buffer')
        map('n', '<Leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<Leader>hi', gs.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<Leader>hd', gs.diffthis, 'Diff this')
        map('n', '<Leader>hD', function()
          gs.diffthis('~')
        end, 'Diff this ~')
        map('n', '<Leader>gb', function()
          gs.blame_line({ full = true })
        end, 'Git blame line')
        map('v', '<Leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Stage hunk')
        map('v', '<Leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Reset hunk')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
      end,
    })
  end),
})

local fd_opts = '--color=never --type f --hidden --follow --strip-cwd-prefix'
local load_fzf = lazy('fzf-lua', function()
  local fzf_lua, actions = require('fzf-lua'), require('fzf-lua.actions')
  fzf_lua.setup({
    'default-title',
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
        wrap = false,
        hidden = false,
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 120,
        scrollbar = 'float',
      },
    },
    fzf_opts = {
      ['--cycle'] = true,
      ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-history',
      ['--history-size'] = '10000',
      ['--tiebreak'] = 'end',
    },
    files = {
      fd_opts = fd_opts .. ' --exclude .git',
      sort_lastused = true,
      fzf_opts = { ['--tiebreak'] = 'end' },
      actions = { ['ctrl-q'] = actions.file_edit_or_qf },
    },
    buffers = {
      sort_lastused = true,
      actions = {
        ['ctrl-q'] = actions.file_edit_or_qf,
        ['ctrl-x'] = { fn = actions.buf_del, reload = true },
      },
    },
    grep = {
      rg_opts = table.concat({
        '--color=never --column --line-number --no-heading --smart-case',
        '--max-columns=4096 --hidden --trim',
        "--glob '!.git/*' --glob '!*.lock'",
        '-e',
      }, ' '),
      actions = {
        ['ctrl-q'] = actions.file_edit_or_qf,
        ['ctrl-g'] = actions.grep_lgrep,
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
        ['<C-_>'] = 'toggle-preview',
      },
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-a'] = 'toggle-all',
        ['ctrl-d'] = 'preview-page-down',
        ['ctrl-u'] = 'preview-page-up',
        ['ctrl-/'] = 'toggle-preview',
        ['ctrl-_'] = 'toggle-preview',
      },
    },
  })
  fzf_lua.register_ui_select()
end)

---@param action string
---@param opts? table
---@return fun()
local function fzf(action, opts)
  return function()
    load_fzf()
    require('fzf-lua')[action](opts)
  end
end

for _, m in ipairs({
  { '<Leader><space>', 'files', 'Find files' },
  { '<Leader>/', 'live_grep', 'Live grep' },
  { '<Leader>,', 'buffers', 'Buffers' },
  { '<Leader>ff', 'files', 'Find files' },
  { '<Leader>fg', 'git_files', 'Git files' },
  { '<Leader>fb', 'buffers', 'Buffers' },
  { '<Leader>fr', 'oldfiles', 'Recent files' },
  { '<Leader>sf', 'resume', 'Resume search' },
  { '<Leader>ss', 'lsp_workspace_symbols', 'Workspace symbols' },
  { '<Leader>sd', 'lsp_workspace_diagnostics', 'Workspace diagnostics' },
  { '<Leader>gs', 'git_status', 'Git status' },
  { '<Leader>gl', 'git_commits', 'Git commits' },
  { 'gd', 'lsp_definitions', 'Go to definition' },
  { 'gD', 'lsp_declarations', 'Go to declaration' },
  { 'gr', 'lsp_references', 'References' },
  { 'gI', 'lsp_implementations', 'Implementations' },
  { 'gy', 'lsp_typedefs', 'Type definitions' },
  { '<Leader>ca', 'lsp_code_actions', 'Code actions' },
  { '<Leader>p', 'registers', 'Registers' },
  { '<Leader>ch', 'changes', 'Changes' },
  { '<Leader>fc', 'files', 'Find config files', { cwd = vim.fn.stdpath('config') } },
  { '<Leader>fa', 'files', 'Find files (incl. gitignored)', { fd_opts = fd_opts .. ' --no-ignore-vcs' } },
}) do
  vim.keymap.set('n', m[1], fzf(m[2], m[4]), { silent = true, desc = m[3] })
end

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'Leap forward' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap from window' })
