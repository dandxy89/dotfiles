-- Lazy loading setup for plugins
local M = {}

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

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
          vim.cmd('packadd ' .. plugin.name)
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
        vim.cmd('packadd ' .. name)
      end
      action()
    end, {})
  end

  -- Helper: Create test commands
  ---@param cmd_name string
  ---@param test_cmd string
  local function create_test_command(cmd_name, test_cmd)
    create_lazy_command(cmd_name, { 'vim-test', 'vimux' }, function()
      vim.cmd("let test#strategy = 'vimux'")
      vim.cmd(test_cmd)
    end)
  end

  -- Setup trigger-based lazy loading
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
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

  -- Command-based lazy loading
  create_lazy_command('Spectre', 'nvim-spectre', function()
    require('plugins.config.spectre')
    require('spectre').open()
  end)

  create_test_command('TestNearest', 'TestNearest')
  create_test_command('TestFile', 'TestFile')

  -- Keymap-based lazy loading (tmux navigation)
  for _, key in ipairs({ '<C-h>', '<C-j>', '<C-k>', '<C-l>' }) do
    vim.keymap.set('n', key, function()
      if not loaded_groups.keymap then
        loaded_groups.keymap = true
        vim.cmd('packadd vim-tmux-navigator')
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
      vim.cmd('packadd ferris.nvim')
      local keymap = require('util.keymap')
      keymap.set_batch('n', {
        { '<Leader>ml', ':lua require("ferris.methods.view_memory_layout")()<CR>' },
        { '<Leader>em', ':lua require("ferris.methods.expand_macro")()<CR>' },
        { '<Leader>od', ':lua require("ferris.methods.open_documentation")()<CR>' },
      })
    end,
  })
end

return M
