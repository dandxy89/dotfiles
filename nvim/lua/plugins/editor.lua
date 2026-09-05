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
          map('n', '<Leader>hR', gs.reset_buffer, 'Reset buffer')
          map('n', '<Leader>hp', gs.preview_hunk, 'Preview hunk')
          map('n', '<Leader>hd', gs.diffthis, 'Diff this')
          map('n', '<Leader>hD', function()
            gs.diffthis('~')
          end, 'Diff this ~')
          map('n', '<Leader>hi', gs.preview_hunk_inline, 'Preview hunk inline')

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
    'A7Lavinraj/fyler.nvim',
    cmd = { 'Fyler' },
    config = function()
      require('fyler').setup({})
    end,
  },
  {
    'abecodes/tabout.nvim',
    -- Eager so its global <Tab>/<S-Tab> maps exist before blink applies its
    -- buffer-local ones on InsertEnter; blink's fallback then reaches tabout.
    lazy = false,
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('tabout').setup({ completion = false })
    end,
  },
}
