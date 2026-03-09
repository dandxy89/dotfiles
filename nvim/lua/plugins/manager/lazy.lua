-- Lazy loading setup for plugins
local M = {}

---@param plugins Plugin[]
function M.setup_lazy_loading(plugins)
  local loaded_groups = {}

  -- Helper: Create trigger loader for autocmds
  ---@param trigger_name string
  ---@param post_load_fn? function
  ---@return function
  local function create_trigger_loader(trigger_name, post_load_fn)
    return function()
      if loaded_groups[trigger_name] then
        return
      end
      loaded_groups[trigger_name] = true

      for _, plugin in ipairs(plugins) do
        if plugin.opt and plugin.trigger == trigger_name then
          vim.cmd.packadd(plugin.name)
        end
      end

      if post_load_fn then
        post_load_fn()
      end
    end
  end

  -- Helper: Create lazy-load command
  ---@param cmd_name string
  ---@param plugin_names string|string[]
  ---@param action function
  local function create_lazy_command(cmd_name, plugin_names, action)
    vim.api.nvim_create_user_command(cmd_name, function()
      for _, name in ipairs(type(plugin_names) == 'table' and plugin_names or { plugin_names }) do
        vim.cmd.packadd(name)
      end
      action()
    end, {})
  end

  -- Helper: Create test commands
  ---@param cmd_name string
  ---@param test_cmd string
  local function create_test_command(cmd_name, test_cmd)
    create_lazy_command(cmd_name, { 'vim-test', 'vimux' }, function()
      vim.g['test#strategy'] = 'vimux'
      vim.g['test#python#runner'] = 'pytest'
      vim.cmd(test_cmd)
    end)
  end

  -- Setup trigger-based lazy loading
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
    once = true,
    callback = create_trigger_loader('file', function()
      vim.defer_fn(function()
        require('plugins.config.treesitter')
        require('plugins.config.lsp')
        require('plugins.config.gitsigns')
      end, 10)
    end),
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = create_trigger_loader('insert', function()
      require('plugins.config.completion')
    end),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    once = true,
    callback = create_trigger_loader('lsp', function()
      require('lsp-endhints').setup({})
    end),
  })

  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = 'Cargo.toml',
    once = true,
    callback = create_trigger_loader('cargo-toml', function()
      require('crates').setup()
    end),
  })

  -- FZF-lua: lazy load on first keymap use
  local function ensure_fzf()
    if not loaded_groups.fzf then
      loaded_groups.fzf = true
      vim.cmd.packadd('fzf-lua')
      require('plugins.config.fzf')
    end
  end

  -- Register fzf keymaps that lazy-load on first use
  local fzf_keymaps = {
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

  for _, map in ipairs(fzf_keymaps) do
    vim.keymap.set('n', map[1], function()
      ensure_fzf()
      require('fzf-lua')[map[2]]()
    end, { silent = true, noremap = true, desc = map[3] })
  end

  vim.keymap.set('n', '<Leader>fc', function()
    ensure_fzf()
    require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })
  end, { silent = true, noremap = true, desc = 'Find config files' })

  -- Fyler: lazy load on command
  create_lazy_command('Fyler', 'fyler.nvim', function()
    require('plugins.config.fyler')
    vim.cmd('Fyler')
  end)

  -- Lazy loader for grug-far
  local function load_grugfar()
    if not loaded_groups['grug-far.nvim'] then
      loaded_groups['grug-far.nvim'] = true
      vim.cmd.packadd('grug-far.nvim')
      require('plugins.config.grug-far')
    end
  end

  -- Command-based lazy loading
  vim.api.nvim_create_user_command('GrugFar', function()
    load_grugfar()
    require('grug-far').open()
  end, {})

  -- Eager keymaps
  local keymap = require('util.keymap')
  keymap.map('n', '<Leader>S', function()
    load_grugfar()
    require('grug-far').open()
  end, 'GrugFar')
  keymap.map('n', '<Leader>sw', function()
    load_grugfar()
    require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
  end, 'Search current word')
  keymap.map('v', '<Leader>sw', function()
    load_grugfar()
    require('grug-far').with_visual_selection()
  end, 'Search current selection')
  keymap.map('n', '<Leader>sp', function()
    load_grugfar()
    require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
  end, 'Search on current file')

  create_lazy_command('CodeDiff', 'vscode-diff.nvim', function()
    require('vscode-diff').setup()
    vim.cmd('CodeDiff')
  end)

  vim.keymap.set('n', 'cd', '<cmd>CodeDiff<cr>', { desc = 'VSCode diff' })

  create_test_command('TestNearest', 'TestNearest')
  create_test_command('TestFile', 'TestFile')
  create_test_command('TestSuite', 'TestSuite')
  create_test_command('TestLast', 'TestLast')
  create_test_command('TestVisit', 'TestVisit')

  -- Keymap-based lazy loading (tmux navigation)
  for _, key in ipairs({ '<C-h>', '<C-j>', '<C-k>', '<C-l>' }) do
    vim.keymap.set('n', key, function()
      if not loaded_groups.keymap then
        loaded_groups.keymap = true
        vim.cmd.packadd('vim-tmux-navigator')
        require('plugins.config.tmux')
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
    end, { desc = 'Tmux navigate' })
  end

  -- FileType-based lazy loading (ferris for Rust)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    once = true,
    callback = function()
      vim.cmd.packadd('ferris.nvim')
      local keymap = require('util.keymap')
      keymap.set_batch('n', {
        {
          '<Leader>ml',
          function()
            require('ferris.methods.view_memory_layout')()
          end,
        },
        {
          '<Leader>em',
          function()
            require('ferris.methods.expand_macro')()
          end,
        },
        {
          '<Leader>od',
          function()
            require('ferris.methods.open_documentation')()
          end,
        },
      })
    end,
  })
end

return M
