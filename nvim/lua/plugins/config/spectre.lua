require('spectre').setup({
  replace_engine = {
    ['sed'] = { cmd = 'sed', args = { '-i', '', '-E' } },
  },
})

local keymap = require('util.keymap')

keymap.map('n', '<Leader>S', function() require('spectre').toggle() end, 'Toggle Spectre')
keymap.map('n', '<Leader>sw', function() require('spectre').open_visual({ select_word = true }) end, 'Search current word')
keymap.map('v', '<Leader>sw', function() require('spectre').open_visual() end, 'Search current word')
keymap.map('n', '<Leader>sp', function() require('spectre').open_file_search({ select_word = true }) end, 'Search on current file')
