---@param name string
---@return integer
local function augroup(name)
    return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- Forces Neovim to detect file changes on disk immediately
vim.api.nvim_create_user_command("Realtime",
    function()
        vim.opt.autoread = true
        api.nvim_create_autocmd("CursorHold", { pattern = "*", command = "checktime" })
        api.nvim_feedkeys("lh", "n", false) -- Trigger a move to refresh
    end,
    { desc = "Enable realtime autoread (watch file changes)" }
)

-- Format files on save (sync to ensure format completes before write)
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.rs', '*.py' },
    callback = function()
        if not vim.g.disable_autoformat then
            vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
        end
    end,
    group = augroup('FormatOnSave'),
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
        vim.cmd([[ %s/\s\+$//e ]])
    end,
    group = augroup('StripWhitespace'),
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
    group = augroup('dotenv_ft'),
    pattern = { '.env', '.env.*' },
    callback = function()
        vim.bo.filetype = 'dosini'
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight_yank'),
    pattern = '*',
    desc = 'highlight selection on yank',
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

-- Close some filetypes with <Esc>
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('CloseWithEscGrp'),
    pattern = {
        'PlenaryTestPopup',
        'grug-far',
        'help',
        'lspinfo',
        'notify',
        'qf',
        'spectre_panel',
        'checkhealth',
        'dbout',
        'gitsigns-blame',
        'Lazy',
        'man'
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set('n', '<esc>', function()
                vim.cmd('close')
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, { buffer = event.buf, silent = true, desc = 'Quit buffer' })
        end)
    end,
})

-- LSP progress tracking
local lsp_progress = require('util.lsp_progress')
vim.api.nvim_create_autocmd('LspProgress', {
    group = augroup('LspProgressNotifications'),
    callback = function(ev)
        lsp_progress.update(ev.data.client_id, ev.data.params.token, ev.data.params.value)
    end,
})

-- Auto-resize windows when terminal is resized
vim.api.nvim_create_autocmd('VimResized', {
    group = augroup('AutoResizeWindows'),
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})

-- Jump to last position when reopening files
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('JumpToLastPosition'),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('AutoCreateDirs'),
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})
