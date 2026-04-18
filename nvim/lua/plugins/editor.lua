local keymap = require('util.keymap')

return {
  {
    'https://codeberg.org/andyg/leap.nvim.git',
    name = 'leap.nvim',
    lazy = false,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = require('gitsigns')

          local function nav_hunk(direction)
            return function()
              if vim.wo.diff then
                vim.cmd.normal({ direction == 'next' and ']c' or '[c', bang = true })
              else
                gs.nav_hunk(direction)
              end
            end
          end

          keymap.set_batch('n', {
            { ']h', nav_hunk('next'), { desc = 'Next hunk' } },
            { '[h', nav_hunk('prev'), { desc = 'Previous hunk' } },
          }, { buffer = bufnr })

          keymap.set_batch('n', {
            { '<Leader>hs', gs.stage_hunk, { desc = 'Stage hunk' } },
            { '<Leader>hr', gs.reset_hunk, { desc = 'Reset hunk' } },
            { '<Leader>hS', gs.stage_buffer, { desc = 'Stage buffer' } },
            { '<Leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' } },
            { '<Leader>hR', gs.reset_buffer, { desc = 'Reset buffer' } },
            { '<Leader>hp', gs.preview_hunk, { desc = 'Preview hunk' } },
            { '<Leader>hd', gs.diffthis, { desc = 'Diff this' } },
            { '<Leader>hD', function() gs.diffthis('~') end, { desc = 'Diff this ~' } },
            { '<Leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' } },
          }, { buffer = bufnr })

          keymap.set_batch('v', {
            { '<Leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage hunk' } },
            { '<Leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Reset hunk' } },
          }, { buffer = bufnr })

          keymap.set_batch({ 'o', 'x' }, {
            { 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' } },
          }, { buffer = bufnr })
        end,
      })
    end,
  },

  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar' },
    keys = {
      { 'n', '<Leader>S', function() require('grug-far').open() end, { desc = 'GrugFar' } },
      { 'n', '<Leader>sw', function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end, { desc = 'Search current word' } },
      { 'v', '<Leader>sw', function() require('grug-far').with_visual_selection() end, { desc = 'Search current selection' } },
      { 'n', '<Leader>sp', function() require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } }) end, { desc = 'Search on current file' } },
    },
    config = function()
      require('grug-far').setup({})
    end,
  },

  {
    'A7Lavinraj/fyler.nvim',
    cmd = { 'Fyler' },
    config = function()
      require('fyler').setup({})
    end,
  },

  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { 'n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { silent = true, desc = 'Tmux left' } },
      { 'n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { silent = true, desc = 'Tmux down' } },
      { 'n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { silent = true, desc = 'Tmux up' } },
      { 'n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { silent = true, desc = 'Tmux right' } },
      { 'n', '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', { silent = true, desc = 'Tmux previous' } },
    },
  },

  {
    'esmuellert/vscode-diff.nvim',
    cmd = { 'CodeDiff' },
    keys = {
      { 'n', 'cd', '<cmd>CodeDiff<cr>', { desc = 'VSCode diff' } },
    },
    config = function()
      require('vscode-diff').setup()
    end,
  },
}
