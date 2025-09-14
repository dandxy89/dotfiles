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
end)                                                  -- Save file
nnoremap("<Tab>", "<cmd>bNext<CR>")                   -- Next buffer
nnoremap("<S-Tab>", "<cmd>bprevious<CR>")             -- Previous buffer
nnoremap("<F5>", "<cmd>UndotreeToggle<CR>")           -- Toggle UndoTree
nnoremap("<Leader>sr", "<cmd>vs<CR>")                 -- Split right
nnoremap("<Leader>wh", "<cmd>wincmd h<CR>")           -- Switch window left
nnoremap("<Leader>wl", "<cmd>wincmd l<CR>")           -- Switch window right
nnoremap("<Leader>wj", "<cmd>wincmd j<CR>")           -- Switch window down
nnoremap("<Leader>wk", "<cmd>wincmd k<CR>")           -- Switch window up
nnoremap("<Leader>fj", "<cmd>%!jq .<CR>")             -- Format JSON
nnoremap("<Leader>=", "<cmd>vertical resize +10<CR>") -- Resize thinner
nnoremap("<Leader>-", "<cmd>vertical resize -10<CR>") -- Resize wider
nnoremap("<Leader>rh", "<cmd>nohl<CR>")               -- Remove highlight
nnoremap("<F9>", "<cmd>!python %<CR>")                -- Run Python
nnoremap("<C-a>", "gg<S-v>G")                         -- Select all
nnoremap("x", '"_x')                                  -- No map x
nnoremap("<Leader>nf", "<cmd>enew<CR>")               -- New file
nnoremap("<Leader>cn", vim.lsp.buf.rename)            -- Rename
nnoremap("H", "_")                                    -- Start of line
nnoremap("L", "$")                                    -- End of line
nnoremap("J", "}")                                    -- Jump blocks
nnoremap("<C-Z>", "<cmd>undo<CR>")                    -- Undo
nnoremap("<C-Y>", "<cmd>redo<CR>")                    -- Redo
nnoremap("<Leader>fl", vim.lsp.buf.format)            -- Format code
nnoremap("<Leader>de", vim.diagnostic.open_float)     -- Open diagnostics
nnoremap("<BS>", "<C-o>")                             -- Backspace jump
nnoremap("K", vim.lsp.buf.hover)                      -- Hover
nnoremap("<Leader>gd", vim.lsp.buf.declaration)       -- Declaration
nnoremap("[d", vim.diagnostic.goto_prev)              -- Previous diagnostic
nnoremap("]d", vim.diagnostic.goto_next)              -- Next diagnostic
nnoremap("<M-k>", "<cmd>cnext<CR>")                   -- Quickfix next
nnoremap("<M-j>", "<cmd>cprevious<CR>")               -- Quickfix previous

-- Buffer management (C-h/j/k/l handled by tmux navigator in pack.lua)
nnoremap("<Leader>bd", "<cmd>bdelete<CR>") -- Close buffer
nnoremap("<Leader><Tab>", "<C-^>")         -- Toggle buffers
nnoremap("<Leader>ll", function()
    vim.cmd.match(string.format("Visual /%s/", vim.fn.expand("<cword>")))
end) -- Highlight word under cursor

-- VISUAL MODE
local vnoremap = bind("v")
vnoremap("H", "_")                                    -- Start of line
vnoremap("L", "$")                                    -- End of line
vnoremap("K", "<cmd>m '>-2<CR>gv=gv")                 -- Move line up
vnoremap("J", "<cmd>m '>+1<CR>gv=gv")                 -- Move line down
vnoremap("<Leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace selection
-- Better indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- INSERT MODE
local inoremap = bind("i")
inoremap("<C-s>", "<Esc><cmd>w<CR>") -- Save file

-- TERMINAL MODE
local tnoremap = bind("t")
tnoremap("<Esc>", "<C-\\><C-n>") -- Exit terminal
