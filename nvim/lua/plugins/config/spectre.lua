require('spectre').setup({
  replace_engine = {
    ['sed'] = { cmd = 'sed', args = { '-i', '', '-E' } },
  },
})

local keymap = require('util.keymap')

keymap.map('n', '<Leader>S', '<cmd>lua require("spectre").toggle()<CR>', 'Toggle Spectre')
keymap.map('n', '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', 'Search current word')
keymap.map('v', '<Leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', 'Search current word')
keymap.map('n', '<Leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', 'Search on current file')
