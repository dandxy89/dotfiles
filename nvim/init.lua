---@diagnostic disable: undefined-global
require("config.lazy")

require("core.opts")
require("core.autocmds")
require("core.keys")

vim.diagnostic.config({ virtual_lines = true })
