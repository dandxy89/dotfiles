require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local keymap = require('util.keymap')

    local function nav_hunk(direction)
      return function()
        if vim.wo.diff then
          vim.cmd.normal({ direction == 'next' and ']c' or '[c', bang = true })
        else
          gs.nav_hunk(direction)
        end
      end
    end

    -- Navigation
    keymap.set_batch('n', {
      { ']h', nav_hunk('next'), { desc = 'Next hunk' } },
      { '[h', nav_hunk('prev'), { desc = 'Previous hunk' } },
    }, { buffer = bufnr })

    -- Actions
    keymap.set_batch('n', {
      { '<Leader>hs', gs.stage_hunk, { desc = 'Stage hunk' } },
      { '<Leader>hr', gs.reset_hunk, { desc = 'Reset hunk' } },
      { '<Leader>hS', gs.stage_buffer, { desc = 'Stage buffer' } },
      { '<Leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' } },
      { '<Leader>hR', gs.reset_buffer, { desc = 'Reset buffer' } },
      { '<Leader>hp', gs.preview_hunk, { desc = 'Preview hunk' } },
      { '<Leader>hd', gs.diffthis, { desc = 'Diff this' } },
      {
        '<Leader>hD',
        function()
          gs.diffthis('~')
        end,
        { desc = 'Diff this ~' },
      },
      { '<Leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' } },
    }, { buffer = bufnr })

    keymap.set_batch('v', {
      {
        '<Leader>hs',
        function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        { desc = 'Stage hunk' },
      },
      {
        '<Leader>hr',
        function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        { desc = 'Reset hunk' },
      },
    }, { buffer = bufnr })

    -- Text object
    keymap.set_batch({ 'o', 'x' }, {
      { 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' } },
    }, { buffer = bufnr })
  end,
})
