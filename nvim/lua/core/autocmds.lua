---@diagnostic disable: no-unknown, undefined-field
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd(
    { "FocusGained", "TermClose", "TermLeave" },
    { command = "checktime", group = augroup("FocusGainedGrp") }
)

-- Strips unwanted trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
    group = augroup("FormatPreGrp"),
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = augroup("TextYankPostGrp"),
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    group = augroup("ResizeGrp"),
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    command = "set nopaste",
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs" },
    callback = function(ev)
        vim.lsp.buf.format()
    end,
    group = augroup("FormattingGrp"),
})

-- Create an async function to run pytest
local function run_pytest()
    -- Create a new terminal buffer
    vim.cmd("new")

    -- Get the terminal job ID
    local buf = vim.api.nvim_get_current_buf()

    -- Run pytest asynchronously
    local _ = vim.fn.jobstart("pytest", {
        on_stdout = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
            end
        end,
        on_stderr = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
            end
        end,
        on_exit = function(_, code)
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "Pytest finished with exit code: " .. code })
        end,
        stdout_buffered = true,
        stderr_buffered = true,
    })

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") -- This ensures buffer is deleted when closed
    vim.api.nvim_buf_set_name(buf, "Pytest Output")
    vim.api.nvim_buf_set_option(buf, "filetype", "pytest-output")

    -- Add key mapping to close the buffer with 'q'
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":bdelete!<CR>", {
        noremap = true,
        silent = true,
        nowait = true,
    })

    -- Set buffer local options for easy closing
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Create a command to run pytest
vim.api.nvim_create_user_command("PyTest", run_pytest, {})

-- Close some file types with <Esc>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("CloseWithEscGrp"),
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
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
