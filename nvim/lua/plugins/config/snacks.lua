require('snacks').setup({
  bigfile = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 1000,
    win = { backdrop = { transparent = false } },
  },
  statuscolumn = { enabled = true },
  words = { enabled = true },
})

-- Snacks keymaps using table-driven approach
local keymap = require('util.keymap')
local snacks_maps = {
  {
    '<Leader>n',
    function()
      require('snacks').notifier.show_history()
    end,
    'Notification history',
  },
  {
    '<Leader>.',
    function()
      require('snacks').terminal()
    end,
    'Terminal',
  },
  {
    '<Leader>gB',
    function()
      require('snacks').gitbrowse()
    end,
    'Git browse',
  },
  {
    '<Leader>gb',
    function()
      require('snacks').git.blame_line()
    end,
    'Git blame line',
  },
  {
    '<Leader>gf',
    function()
      require('snacks').lazygit.log_file()
    end,
    'Git log file',
  },
  {
    '<Leader>lg',
    function()
      require('snacks').lazygit()
    end,
    'Lazygit',
  },
}

for _, map in ipairs(snacks_maps) do
  keymap.map('n', map[1], map[2], map[3])
end
