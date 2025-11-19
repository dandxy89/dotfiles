require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, 'Next hunk')

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, 'Previous hunk')

    -- Actions
    map('n', '<Leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<Leader>hr', gs.reset_hunk, 'Reset hunk')
    map('v', '<Leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Stage hunk')
    map('v', '<Leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Reset hunk')
    map('n', '<Leader>hS', gs.stage_buffer, 'Stage buffer')
    map('n', '<Leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<Leader>hR', gs.reset_buffer, 'Reset buffer')
    map('n', '<Leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<Leader>hd', gs.diffthis, 'Diff this')
    map('n', '<Leader>hD', function()
      gs.diffthis('~')
    end, 'Diff this ~')
    map('n', '<Leader>td', gs.toggle_deleted, 'Toggle deleted')

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
  end,
})
