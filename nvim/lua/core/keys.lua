local function bind(op, outer_opts)
    outer_opts = vim.tbl_extend("force", { noremap = true, silent = true, nowait = true }, outer_opts or {})

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

-- Quality of Life stuff --
local multiremap = bind({ "n", "s", "v" })
multiremap("<Leader>yy", '"+y')
multiremap("<Leader>yY", '"+yy')
multiremap("<Leader>yp", '"+p')
multiremap("<Leader>yd", '"+d')
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
nnoremap("<F9>", ":!python %<CR>") -- Run Python Script in Buffer
nnoremap("<C-a>", "gg<S-v>G") -- Select all
nnoremap("x", '"_x') -- No map x
nnoremap("<Leader>nf", "<cmd>enew<cr>") -- New file
nnoremap("<Leader>ca", ":lua vim.lsp.buf.code_action()<CR>") -- Code Action
nnoremap("<Leader>cn", ":lua vim.lsp.buf.rename()<CR>") -- Rename
nnoremap("H", "_") -- H to go the start of line(n)
nnoremap("L", "$") -- L to go to the end of line(n)
nnoremap("J", "}") -- J to jump previous blocks(n)
nnoremap("<C-Z>", "<Cmd>undo<CR>") -- Undo
nnoremap("<C-Y>", "<Cmd>redo<CR>") -- Redo
nnoremap("<Leader>fl", ":lua vim.lsp.buf.format()<CR>") -- Format Code
nnoremap("<Leader>de", ":lua vim.diagnostic.open_float()<CR>") -- Open Diagnostics Float
nnoremap("<BS>", "<C-o>") -- Backspace `Ctrl+O`
nnoremap("K", ":lua vim.lsp.buf.hover()<CR>") -- Hover
nnoremap("<Leader>gd", ":lua vim.lsp.buf.declaration()<CR>") -- Declaration
nnoremap("<M-k>", "<Cmd>cnext<CR>") -- Quickfix next
nnoremap("<M-j>", "<Cmd>cprevious<CR>") -- Quickfix previous

-- Better window navigation
nnoremap("<C-h>", "<C-w>h")
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-l>", "<C-w>l")

-- Buffer management
nnoremap("<Leader>bd", ":bdelete<CR>") -- Close current buffer
nnoremap("<Leader><Tab>", "<C-^>") -- Toggle between last two buffers

-- VISUAL MODE
local vnoremap = bind("v")
vnoremap("H", "_") -- H to go the start of line(n)
vnoremap("L", "$") -- L to go to the end of line(n)
vnoremap("K", ":m '>-2<CR>gv=gv") -- Move current line up
vnoremap("J", ":m '>+1<CR>gv=gv") -- Move current line down
vnoremap("<Leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace Selected
-- Better indenting (stay in visual mode)
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- INSERT MODE
local inoremap = bind("i")
inoremap("<C-s>", "<Esc>:w<CR>") -- Save file in insert mode

-- TERMINAL MODE
local tnoremap = bind("t")
tnoremap("<Esc>", "<C-\\><C-n>") -- Exit terminal mode
