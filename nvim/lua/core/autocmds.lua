---@diagnostic disable: no-unknown, undefined-field
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, {clear = true})
end

-- Automatically reload files when they change
vim.api.nvim_create_autocmd({'FocusGained', 'TermClose', 'TermLeave'}, {
    callback = function()
        if vim.fn.filereadable(vim.fn.expand('%')) == 0 then return end
        vim.cmd('checktime')
    end
})

-- Strips unwanted trailing whitespace
-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = '*',
    callback = function(ev)
        if vim.g.disable_autoformat then return end
        if ev.match == "*.rs" then vim.lsp.buf.format({async = true}) end
        vim.cmd([[ %s/\s\+$//e ]]) -- Strip trailing whitespace
    end,
    group = augroup("BufWritePreGrp")
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost',
                            {callback = function() vim.highlight.on_yank() end})

-- Close some file types with <Esc>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("CloseWithEscGrp"),
    pattern = {
        "PlenaryTestPopup", "grug-far", "help", "lspinfo", "notify", "qf",
        "spectre_panel", "checkhealth", "dbout", "gitsigns-blame", "Lazy"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "<esc>", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, {force = true})
            end, {buffer = event.buf, silent = true, desc = "Quit buffer"})
        end)
    end
})

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value
        if not client or type(value) ~= "table" then return end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "", value.message and
                            (" **%s**"):format(value.message) or ""),
                    done = value.kind == "end"
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = {
            "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"
        }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " " or
                                 spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) %
                                     #spinner + 1]
            end
        })
    end
})
