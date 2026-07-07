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

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
          end

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
          map('n', '<Leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
          map('n', '<Leader>hR', gs.reset_buffer, 'Reset buffer')
          map('n', '<Leader>hp', gs.preview_hunk, 'Preview hunk')
          map('n', '<Leader>hd', gs.diffthis, 'Diff this')
          map('n', '<Leader>hD', function()
            gs.diffthis('~')
          end, 'Diff this ~')
          map('n', '<Leader>td', gs.toggle_deleted, 'Toggle deleted')

          map('v', '<Leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, 'Stage hunk')
          map('v', '<Leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, 'Reset hunk')

          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
        end,
      })
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar' },
    keys = {
      {
        'n',
        '<Leader>S',
        function()
          require('grug-far').open()
        end,
        { desc = 'GrugFar' },
      },
      {
        'n',
        '<Leader>sw',
        function()
          require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
        end,
        { desc = 'Search current word' },
      },
      {
        'v',
        '<Leader>sw',
        function()
          require('grug-far').with_visual_selection()
        end,
        { desc = 'Search current selection' },
      },
      {
        'n',
        '<Leader>sp',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
        end,
        { desc = 'Search on current file' },
      },
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
  {
    'rashedInt32/lazydiff.nvim',
    cmd = { 'Lazydiff', 'LazydiffOff', 'LazydiffRefresh', 'LazydiffNext', 'LazydiffPrev', 'LazydiffFirst' },
    keys = {
      { 'n', '<Leader>hl', '<cmd>Lazydiff<cr>', { desc = 'Toggle lazydiff overlay' } },
    },
    config = function()
      require('lazydiff').setup()
    end,
  },
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = { 'LspAttach' },
    config = function()
      require('lsp-endhints').setup({})
    end,
  },
}
