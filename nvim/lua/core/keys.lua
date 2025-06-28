local function bind(op, outer_opts)
    outer_opts = vim.tbl_extend("force", { noremap = true, silent = true, nowait = true }, outer_opts or {})

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

-- Quality of Life stuff --
local multiremap = bind({ "n", "s", "v" })
multiremap("<Leader>y", '"+y', { desc = "Copy to system clipboard" })
multiremap("<Leader>p", '"+p', { desc = "Paste from system clipboard" })
multiremap("<Leader>d", '"+d', { desc = "Cut to system clipboard" })
multiremap("<Space>", "<Nop>")

-- NORMAL MODE
local nnoremap = bind("n")
nnoremap("<Leader>w", function()
    vim.cmd("silent! write!")
    vim.notify("File saved")
end) -- Faster Saving
nnoremap("<Leader>lz", ":Lazy<CR>") -- Open Lazy
nnoremap("<Tab>", ":bNext<CR>") -- Next Buffer
nnoremap("<S-Tab>", ":bprevious<CR>") -- Previous Buffer
nnoremap("<F5>", ":UndotreeToggle<CR>") -- Toggle UndoTree Plugin
nnoremap("<Leader>sr", ":vs<CR>") -- Split Right
nnoremap("<Leader>wh", ":wincmd h<CR>") -- Switch Window - Left
nnoremap("<Leader>wl", ":wincmd l<CR>") -- Switch Window - Right
nnoremap("<Leader>wj", ":wincmd j<CR>") -- Switch Window - Down
nnoremap("<Leader>wk", ":wincmd k<CR>") -- Switch Window - Up
nnoremap("<Leader>fj", ":%!jq .<CR>") -- Format Json
nnoremap("<Leader>=", ":vertical resize +10<CR>") -- Resize - thinner buffer
nnoremap("<Leader>-", ":vertical resize -10<CR>") -- Resize - widen buffer
nnoremap("<Leader>rh", ":nohl<CR>") -- Remove search highlighting
nnoremap("<F9>", ":!python %<CR>", { desc = "Run Python script" }) -- Consider using a more flexible runner
nnoremap("<C-a>", "gg<S-v>G", { desc = "Select all text" })
nnoremap("x", '"_x', { desc = "Delete char without yanking" })
nnoremap("<Leader>nf", "<cmd>enew<cr>") -- New file
nnoremap("<Leader>ca", function()
    vim.lsp.buf.code_action()
end, { desc = "Code Action" })
nnoremap("<Leader>cn", function()
    vim.lsp.buf.rename()
end, { desc = "Rename Symbol" })
nnoremap("H", "_", { desc = "Go to start of line" })
nnoremap("L", "$", { desc = "Go to end of line" })
nnoremap("J", "}", { desc = "Jump to next paragraph" })
nnoremap("<C-Z>", "<Cmd>undo<CR>", { desc = "Undo" })
nnoremap("<C-Y>", "<Cmd>redo<CR>", { desc = "Redo" })
nnoremap("<Leader>fl", function()
    vim.lsp.buf.format()
end, { desc = "Format Code" })
nnoremap("<Leader>de", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics Float" })
nnoremap("<BS>", "<C-o>", { desc = "Jump back in jumplist" })
nnoremap("K", function()
    vim.lsp.buf.hover()
end, { desc = "LSP Hover" })
-- Declaration is handled by Snacks picker in snacks.lua
nnoremap("<M-k>", "<Cmd>cnext<CR>", { desc = "Next quickfix item" })
nnoremap("<M-j>", "<Cmd>cprevious<CR>", { desc = "Previous quickfix item" })
nnoremap("<Leader>ll", function()
    vim.cmd.match(string.format("Visual /%s/", vim.fn.expand("<cword>")))
end, { desc = "Highlight word under cursor" })

-- VISUAL MODE
local vnoremap = bind("v")
vnoremap("H", "_") -- H to go the start of line(n)
vnoremap("L", "$") -- L to go to the end of line(n)
vnoremap("K", ":m '>-2<CR>gv=gv") -- Move current line up
vnoremap("J", ":m '>+1<CR>gv=gv") -- Move current line down
vnoremap("<Leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace Selected

-- INSERT MODE
local inoremap = bind("i")
inoremap("<C-s>", "<Esc>:w<CR>") -- Save file in insert mode

-- TERMINAL MODE
local tnoremap = bind("t")
tnoremap("<Esc>", "<C-\\><C-n>") -- Exit terminal mode
