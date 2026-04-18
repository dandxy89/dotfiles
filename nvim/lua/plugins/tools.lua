return {
  { 'nvim-lua/plenary.nvim' },
  { 'MunifTanjim/nui.nvim' },

  {
    'ibhagwan/fzf-lua',
    keys = (function()
      local k = {
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
      }
      local keys = {}
      for _, m in ipairs(k) do
        local action = m[2]
        table.insert(keys, {
          'n',
          m[1],
          function() require('fzf-lua')[action]() end,
          { silent = true, noremap = true, desc = m[3] },
        })
      end
      table.insert(keys, {
        'n',
        '<Leader>fc',
        function() require('fzf-lua').files({ cwd = vim.fn.stdpath('config') }) end,
        { silent = true, noremap = true, desc = 'Find config files' },
      })
      return keys
    end)(),
    config = function()
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
          fd_opts = '--color=never --type f --hidden --follow --strip-cwd-prefix --no-ignore-vcs',
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
          rg_opts = table.concat({
            '--color=never --column --line-number --no-heading --smart-case',
            '--max-columns=4096 --hidden --trim --no-ignore-vcs',
            "--glob '!.git/*' --glob '!node_modules/*' --glob '!target/*'",
            "--glob '!.venv/*' --glob '!dist/*' --glob '!.terraform/*'",
            "--glob '!*.lock'",
            '-e',
          }, ' '),
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
    end,
  },
}
