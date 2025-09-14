vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.pack")
require("core.opts")
require("core.autocmds")
require("core.keys")
