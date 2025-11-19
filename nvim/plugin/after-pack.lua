-- This file loads AFTER pack plugins are loaded because it's in the plugin/ directory

require("plugins.config.theme")
require("plugins.config.snacks")
require("plugins.config.fzf")

-- Defer statusline until first buffer
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    once = true,
    callback = function()
        require("plugins.config.statusline")
    end
})

pcall(require, "plugins.config.copilot")
