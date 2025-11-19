-- Plugin management system using native vim.pack
--
-- Installation path (managed by vim.pack):
--   macOS/Linux: ~/.local/share/nvim/site/pack/core/opt/
--
-- All plugins are installed to 'opt' by vim.pack and loaded via vim.pack.add()
-- Lazy loading is handled by custom triggers (opt = true, trigger = ...)

local plugins = {
  -- (always loaded)
  -- { src = "https://github.com/deparr/tairiki.nvim", name = "tairiki.nvim", opt = false },
  { src = 'https://github.com/dapovich/anysphere.nvim', name = 'anysphere.nvim', opt = false },
  { src = 'https://github.com/nvim-lua/plenary.nvim', name = 'plenary.nvim', opt = false },
  { src = 'https://github.com/MunifTanjim/nui.nvim', name = 'nui.nvim', opt = false },
  { src = 'https://github.com/folke/snacks.nvim', name = 'snacks.nvim', opt = false },
  { src = 'https://github.com/ggandor/leap.nvim', name = 'leap.nvim', opt = false },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'nvim-treesitter', opt = false },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', name = 'nvim-treesitter-textobjects', opt = false },
  { src = 'https://github.com/williamboman/mason.nvim', name = 'mason.nvim', opt = false },
  { src = 'https://github.com/ibhagwan/fzf-lua', name = 'fzf-lua', opt = false },
  { src = 'https://github.com/echasnovski/mini.icons', name = 'mini.icons', opt = false },
  { src = 'https://github.com/A7Lavinraj/fyler.nvim', name = 'fyler.nvim', opt = false },
  -- (lazy)
  { src = 'https://github.com/williamboman/mason-lspconfig.nvim', name = 'mason-lspconfig.nvim', opt = true, trigger = 'file' },
  { src = 'https://github.com/chrisgrieser/nvim-lsp-endhints', name = 'nvim-lsp-endhints', opt = true, trigger = 'lsp' },
  {
    src = 'https://github.com/saghen/blink.cmp',
    name = 'blink-cmp',
    opt = true,
    trigger = 'insert',
    build = 'cargo build --release',
  },
  {
    src = 'https://github.com/saghen/blink.pairs',
    name = 'blink-pairs',
    opt = true,
    trigger = 'insert',
    build = 'cargo build --release',
  },
  { src = 'https://github.com/saghen/blink.indent', name = 'blink-indent', opt = true, trigger = 'file' },
  { src = 'https://github.com/mikavilpas/blink-ripgrep.nvim', name = 'blink-ripgrep.nvim', opt = true, trigger = 'insert' },
  { src = 'https://github.com/ribru17/blink-cmp-spell', name = 'blink-cmp-spell', opt = true, trigger = 'insert' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim', name = 'gitsigns.nvim', opt = true, trigger = 'file' },
  { src = 'https://github.com/nvim-pack/nvim-spectre', name = 'nvim-spectre', opt = true, trigger = 'command' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator', name = 'vim-tmux-navigator', opt = true, trigger = 'keymap' },
  { src = 'https://github.com/vim-test/vim-test', name = 'vim-test', opt = true, trigger = 'command' },
  { src = 'https://github.com/preservim/vimux', name = 'vimux', opt = true, trigger = 'command' },
  { src = 'https://github.com/vxpm/ferris.nvim', name = 'ferris.nvim', opt = true, trigger = 'filetype:rust' },
  { src = 'https://github.com/Saecki/crates.nvim', name = 'crates.nvim', opt = true, trigger = 'cargo-toml' },
}

-- Register all plugins with vim.pack at startup
-- This allows vim.pack.update() to work properly
local pack_specs = {}
for _, plugin in ipairs(plugins) do
  table.insert(pack_specs, {
    src = plugin.src,
    name = plugin.name,
  })
end
vim.pack.add(pack_specs)

-- Load manager modules
local install = require('plugins.manager.install')
local update = require('plugins.manager.update')
local lazy = require('plugins.manager.lazy')

-- Check for missing plugins on startup
install.ensure_plugins_startup(plugins)

-- Setup commands
install.setup_command(plugins)
update.setup_command(plugins)

-- Simple status command using vim.pack.get()
vim.api.nvim_create_user_command('PackStatus', function()
  ---@type {name: string, src: string}[]
  local all_plugins = vim.pack.get()
  print('Installed plugins managed by vim.pack:')
  for _, plugin in ipairs(all_plugins) do
    print('  - ' .. plugin.name .. ' [' .. plugin.src .. ']')
  end
  print('\nTotal: ' .. #all_plugins .. ' plugins')
  print('\nFor detailed info: :lua vim.print(vim.pack.get())')
end, { desc = 'Show installed plugins' })

-- Delete/remove command using vim.pack.del()
-- When called without args, detects and removes orphaned plugins
vim.api.nvim_create_user_command('PackDelete', function(opts)
  if opts.args == '' then
    -- Detect orphaned plugins (installed but not in config)
    ---@type {name: string, src: string}[]
    local installed = vim.pack.get()
    local configured = {}
    for _, plugin in ipairs(plugins) do
      configured[plugin.name] = true
    end

    local orphaned = {}
    for _, plugin in ipairs(installed) do
      if not configured[plugin.name] then
        table.insert(orphaned, plugin.name)
      end
    end

    if #orphaned == 0 then
      print('✨ No orphaned plugins found. All clean!')
      return
    end

    print('Found ' .. #orphaned .. ' orphaned plugin(s) not in config:')
    for _, name in ipairs(orphaned) do
      print('  - ' .. name)
    end
    print('\nDelete them? (y/N): ')

    local confirm = vim.fn.input(''):lower()
    if confirm == 'y' or confirm == 'yes' then
      local deleted_count = 0
      for _, name in ipairs(orphaned) do
        local success = pcall(vim.pack.del, name)
        if success then
          deleted_count = deleted_count + 1
          print('Deleted: ' .. name)
        else
          print('Failed to delete: ' .. name)
        end
      end
      print('\n✅ Deleted ' .. deleted_count .. ' orphaned plugin(s).')
      print('Restart Neovim to complete removal.')
    else
      print('Cancelled.')
    end
    return
  end

  -- Delete specific plugin by name
  local plugin_name = opts.args
  local success, err = pcall(vim.pack.del, plugin_name)

  if success then
    print('✅ Deleted plugin: ' .. plugin_name)
    print('Restart Neovim to complete removal.')
  else
    print('❌ Failed to delete ' .. plugin_name .. ': ' .. tostring(err))
  end
end, {
  nargs = '?',
  desc = 'Delete orphaned plugins (no args) or specific plugin by name',
  complete = function()
    ---@type {name: string, src: string}[]
    local installed = vim.pack.get()
    local names = {}
    for _, plugin in ipairs(installed) do
      table.insert(names, plugin.name)
    end
    return names
  end,
})

-- Setup lazy loading
lazy.setup_lazy_loading(plugins)

return {
  plugins = plugins,
  setup_lazy_loading = function()
    lazy.setup_lazy_loading(plugins)
  end,
}
