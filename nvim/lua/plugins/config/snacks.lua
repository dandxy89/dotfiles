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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>e", function() require("snacks").explorer() end, opts)
vim.keymap.set("n", "<Leader>n", function() require("snacks").notifier.show_history() end, opts)
vim.keymap.set("n", "<Leader>d", function() require("snacks").bufdelete() end, opts)
vim.keymap.set("n", "<Leader>.", function() require("snacks").terminal() end, opts)
vim.keymap.set("n", "<Leader>gB", function() require("snacks").gitbrowse() end, opts)
vim.keymap.set("n", "<Leader>gb", function() require("snacks").git.blame_line() end, opts)
vim.keymap.set("n", "<Leader>gf", function() require("snacks").lazygit.log_file() end, opts)
vim.keymap.set("n", "<Leader>lg", function() require("snacks").lazygit() end, opts)

