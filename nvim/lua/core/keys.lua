local function bind(op, outer_opts)
    outer_opts = vim.tbl_extend("force", { noremap = true, silent = true, nowait = true }, outer_opts or {})

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nnoremap = bind("n")
local vnoremap = bind("v")

-- NORMAL MODE
nnoremap("<Leader>w", ":w<CR>") -- Faster Saving
nnoremap("<Space>", "<Nop>") -- Nop Space bar
nnoremap("<Leader>lz", ":Lazy<CR>") -- Open Lazy
nnoremap("<Tab>", ":bNext<CR>") -- Next Buffer
nnoremap("<S-Tab>", ":bprevious<CR>") -- Previous Buffer
nnoremap("<F5>", ":UndotreeToggle<CR>") -- Toggle UndoTree Plugin
nnoremap("<Leader>sr", ":vs<CR>") -- Split Right
nnoremap("<Leader>wh", ":wincmd h<CR>") -- Switch Window - Left
nnoremap("<Leader>wl", ":wincmd l<CR>") -- Switch Window - Right
nnoremap("<Leader>wj", ":wincmd j<CR>") -- Switch Window - Down
nnoremap("<Leader>wk", ":wincmd l<CR>") -- Switch Window - Up
nnoremap("<Leader>fj", ":%!jq .<CR>") -- Format Json
nnoremap("<Leader>=", ":vertical resize +10<CR>") -- Resize - thinner buffer
nnoremap("<Leader>-", ":vertical resize -10<CR>") -- Resize - widen buffer
nnoremap("<Leader>rh", ":nohl<CR>") -- Remove search highlighting
nnoremap("<F9>", ":!python %<CR>") -- Run Python Script in Buffer
nnoremap("<Leader>f", ":lua require('fzf-lua').files()<CR>") -- File list
nnoremap("<Leader>lg", ":lua require('fzf-lua').live_grep()<CR>") -- Live Grep
nnoremap("<Leader>fb", ":lua require('fzf-lua').buffers()<CR>") -- Buffer list
nnoremap("<Leader>di", ":lua require('fzf-lua').lsp_workspace_diagnostics({})<CR>") -- Project diagnostics
nnoremap("<Leader>my", ":lua require('fzf-lua').files({ cwd = '~/.config/nvim' })<CR>") -- NVIM Configuration
nnoremap("<Leader>fr", ":lua require('fzf-lua').resume()<CR>") -- Resume fzf search
nnoremap("<Leader>fs", ":lua require('fzf-lua').spell_suggest()<CR>") -- Spelling suggestions
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
nnoremap("gR", ":Glance references<CR>") -- Show references
nnoremap("gD", ":Glance definitions<CR>") -- Show definitions
nnoremap("gM", ":Glance implementations<CR>") -- Show implementations
nnoremap("gY", ":Glance type_definitions<CR>") -- Show type definitions
nnoremap("<Leader>e", ":lua vim.diagnostic.open_float()<CR>") -- Open Diagnostics Float
nnoremap("<BS>", "<C-o>") -- Backspace `Ctrl+O`
nnoremap("<F3>", ":lua vim.lsp.buf.rename()<CR>") -- Rename
nnoremap("K", ":lua vim.lsp.buf.hover()<CR>") -- Hover
nnoremap("<Leader>gd", ":lua vim.lsp.buf.declaration()<CR>") -- Declaration
nnoremap("<M-k>", "<Cmd>cnext<CR>") -- Quickfix next
nnoremap("<M-j>", "<Cmd>cprevious<CR>") -- Quickfix previous

vnoremap("H", "_") -- H to go the start of line(n)
vnoremap("L", "$") -- L to go to the end of line(n)
vnoremap("K", ":m '>-2<CR>gv=gv") -- Move current line up
vnoremap("J", ":m '>+1<CR>gv=gv") -- Move current line down
vnoremap("<Leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace Selected
vnoremap("<space>", "<Nop>") -- Disable Space bar since it'll be used as the leader key
