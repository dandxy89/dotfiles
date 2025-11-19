require("snacks").setup({
    animate = { enabled = false },
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    debug = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = true, replace_netrw = true },
    indent = { enabled = false },
    input = { enabled = false },
    notifier = {
        enabled = true,
        timeout = 1000,
        win = { backdrop = { transparent = false } },
    },
    picker = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

-- require('leap').set_default_mappings()
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')

-- Snacks keymaps using table-driven approach
local keymap = require("util.keymap")
local snacks_maps = {
    { "<Leader>e",  function() require("snacks").explorer() end,               "Explorer" },
    { "<Leader>n",  function() require("snacks").notifier.show_history() end,  "Notification history" },
    { "<Leader>d",  function() require("snacks").bufdelete() end,              "Delete buffer" },
    { "<Leader>.",  function() require("snacks").terminal() end,               "Terminal" },
    { "<Leader>gB", function() require("snacks").gitbrowse() end,              "Git browse" },
    { "<Leader>gb", function() require("snacks").git.blame_line() end,         "Git blame line" },
    { "<Leader>gf", function() require("snacks").lazygit.log_file() end,       "Git log file" },
    { "<Leader>lg", function() require("snacks").lazygit() end,                "Lazygit" },
}

for _, map in ipairs(snacks_maps) do
    keymap.map("n", map[1], map[2], map[3])
end

