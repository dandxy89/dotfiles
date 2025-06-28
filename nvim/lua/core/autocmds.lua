local function augroup(name)
    return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

-- Automatically reload files when they change
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
        if vim.fn.filereadable(vim.fn.expand("%")) == 0 then
            return
        end
        vim.cmd("checktime")
    end,
})

-- Format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        if vim.g.disable_autoformat then
            return
        end
        vim.lsp.buf.format({ async = false }) -- Use sync for write events
    end,
    group = augroup("FormatOnSave"),
})

-- Strip trailing white space on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[ %s/\s\+$//e ]])
        vim.fn.setpos(".", save_cursor)
    end,
    group = augroup("StripWhitespace"),
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
    group = augroup("HighlightYank"),
})

-- Close some filetypes with <Esc>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("CloseWithEsc"),
    pattern = {
        "PlenaryTestPopup",
        "grug-far",
        "help",
        "lspinfo",
        "notify",
        "qf",
        "spectre_panel",
        "checkhealth",
        "dbout",
        "gitsigns-blame",
        "Lazy",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "<esc>", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
        end)
    end,
})

-- Simplified LSP progress notifications
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        local value = ev.data.params.value
        if not value or type(value) ~= "table" then
            return
        end

        -- Only show notifications for significant events
        if value.kind == "end" and value.title then
            vim.notify(
                string.format("%s completed", value.title),
                vim.log.levels.INFO,
                { title = client.name, timeout = 1000 }
            )
        end
    end,
    group = augroup("LspProgress"),
})
