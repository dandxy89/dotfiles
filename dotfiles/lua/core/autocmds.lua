-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Strips unwanted trailing whitespace
local format_sync_grp = vim.api.nvim_create_augroup("FormatPreWrt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
    group = format_sync_grp,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.tex", "*.rs" },
    callback = function()
        vim.api.nvim_set_option_value("spell", true, {})
    end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = false
        vim.opt_local.spell = true
    end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

-- Autoclose the nvimtree once I leave the pane
vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        if vim.bo.filetype == "neo-tree" then
            vim.cmd "q"
        end
    end,
})
