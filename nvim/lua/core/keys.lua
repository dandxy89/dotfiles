--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Key Maps                           ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
--
--
-- Useful links:
--  1. https://vim.fandom.com/wiki/Search_and_replace_in_a_visual_selection
--  2. https://quickref.me/vim
--
-- [[Code Folding]]
--
--  zf - create
--  zo - open
--  zc - Close
--
-- [[Spelling]]
--  [s ]s - find Spelling errors
--  zg - adds to local store
--  z= - offer Spelling suggestions
--
local function bind(op, outer_opts)
    outer_opts = vim.tbl_extend(
        "force", { noremap = true, silent = true, nowait = true }, outer_opts or {}
    )

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nnoremap = bind("n")
local vnoremap = bind("v")
local tnoremap = bind("t")

-- Open Telescope. If in a git repo, use git_files, otherwise use find_files
function OpenTelescope()
    if os.execute('git rev-parse --is-inside-work-tree 2> /dev/null') == 0 then
        require('telescope.builtin').git_files()
    else
        require('telescope.builtin').find_files()
    end
end

function FindAndReplaceFile()
    local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end

-- NORMAL MODE
nnoremap("S", function() FindAndReplaceFile() end)                                -- Press 'S' for quick find/replace for the word under the cursor
nnoremap("<Leader>w", ":w<CR>")                                                   -- Faster Saving
nnoremap("<Leader>n", ":15Lex<CR>")                                               -- Netrw
nnoremap("<Leader>nb", vim.cmd.Explore)                                           -- Netrw as a Buffer
nnoremap("<Leader>cf", "<cmd>let @+ = expand(\"%\")<CR>")                         -- Copy File Name
nnoremap("<Leader>cp", "<cmd>let @+ = expand(\"%:p\")<CR>")                       -- Copy File Path
nnoremap("<Leader>lz", ":Lazy<CR>")                                               -- Open Lazy
nnoremap("<Tab>", ":bNext<CR>")                                                   -- Next Buffer
nnoremap("<S-Tab>", ":bprevious<CR>")                                             -- Previous Buffer
nnoremap("<Leader>d", ":bd! <CR>")                                                -- Delete Buffer
nnoremap("<F5>", ":UndotreeToggle<CR>")                                           -- Toggle UndoTree Plugin
nnoremap("<Leader>sr", ":vs<CR>")                                                 -- Split Right
nnoremap("<Leader>wh", ":wincmd h<CR>")                                           -- Switch Window - Left
nnoremap("<Leader>wl", ":wincmd l<CR>")                                           -- Switch Window - Right
nnoremap("<Leader>mt", ":terminal make test<CR>")                                 -- Run Make Test
nnoremap("<Leader>gf", ":!black %<CR>")                                           -- Run the Black formatter
nnoremap("<Leader>gfl", ":!stylua %<CR>")                                         -- Run the Stylua formatter
nnoremap("<Leader>fj", ":%!jq .<CR>")                                             -- Format Json
nnoremap("<Leader>=", ":vertical resize +10<CR>")                                 -- Resize - thinner buffer
nnoremap("<Leader>-", ":vertical resize -10<CR>")                                 -- Resize - widen buffer
nnoremap("<Leader>rh", ":nohl<CR>")                                               -- Remove search highlighting
nnoremap("<F9>", ":!python %<CR>")                                                -- Run Python Script in Buffer
nnoremap("<Leader>gs", ":Telescope git_status<CR>")                               -- Telescope: Git Status
nnoremap("<Leader>op", ":Telescope whaler<CR>")                                   -- Known Projects
nnoremap("<Leader>f", function() OpenTelescope() end)                             -- Find Files
nnoremap("<Leader>nc", ":Telescope find_files cwd=~/.config/nvim<CR>")            -- Edit Nvim Config
nnoremap("<Leader>lg", ":Telescope live_grep<CR>")                                -- Live grep
nnoremap("<Leader>bl", ":Telescope buffers<CR>")                                  -- Buffer list
nnoremap("<Leader>ws", ":Telescope lsp_workspace_symbols<CR>")                    -- LSP Workspace Symbols
nnoremap("<Leader>ds", ":Telescope lsp_document_symbols<CR>")                     -- Document Symbols
nnoremap("<Leader>di", ":Telescope diagnostics<CR>")                              -- LSP Diagnostics
nnoremap("<Leader><tab>", "<Cmd>lua require('telescope.builtin').commands()<CR>") -- Options in Telescope
nnoremap("<C-a>", "gg<S-v>G")                                                     -- Select all
nnoremap("x", '"_x')                                                              -- No map x
nnoremap("<Leader>nf", "<cmd>enew<cr>")                                           -- New file
nnoremap("<Leader>nl", ":lua require('noice').cmd('last')<CR>")                   -- Noice Last
nnoremap("<Leader>nh", ":lua require('noice').cmd('history')<CR>")                -- Noice History
nnoremap("<Leader>nd", "<cmd>NoiceDismiss<CR>")                                   -- Noice Dismiss
nnoremap("<Leader>ca", ":lua vim.lsp.buf.code_action()<CR>")                      -- Code Action
nnoremap("H", "_")                                                                -- H to go the start of line(n)
nnoremap("L", "$")                                                                -- L to go to the end of line(n)
nnoremap("J", "}")                                                                -- J to jump previous blocks(n)
nnoremap("<C-Z>", "<Cmd>undo<CR>")                                                -- Undo
nnoremap("<C-Y>", "<Cmd>redo<CR>")                                                -- Redo
nnoremap("<Leader>fl", ":lua vim.lsp.buf.format()<CR>")                           -- Format Code
nnoremap("gR", ":Glance references<CR>")                                          -- Show references
nnoremap("gD", ":Glance definitions<CR>")                                         -- Show definitions
nnoremap("gM", ":Glance implementations<CR>")                                     -- Show implementations
nnoremap("gY", ":Glance type_definitions<CR>")                                    -- Show type definitions
nnoremap("<Leader>e", ":lua vim.diagnostic.open_float()<CR>")                     -- Open Diagnostics Float
nnoremap("<Leader>tt", ":vnew term://zsh<CR>")                                    -- Open Terminal
nnoremap("<Leader>gg", ":LazyGit<CR>")                                            -- LazyGit Command Shell
nnoremap("<BS>", "<C-o>")                                                         -- Backspace Cnrl+O"
-- nnoremap()

-- VISUAL MODE
vnoremap("<Tab>", ">gv")                               -- Tab/Shift+tab to indent/dedent
vnoremap("<S-Tab>", "<<")                              -- Tab/Shift+tab to indent/dedent
vnoremap("H", "_")                                     -- H to go the start of line(n)
vnoremap("L", "$")                                     -- L to go to the end of line(n)
vnoremap("K", ":m '>-2<CR>gv=gv")                      -- Move current line up
vnoremap("J", ":m '>+1<CR>gv=gv")                      -- Move current line down
vnoremap("<Leader>r", "\"hy:%s/<C-r>h//g<left><left>") -- Replace Selected
vnoremap("<space>", "<nop>")                           -- Disable Space bar since it'll be used as the leader key
-- vnoremap()

-- TERMINAL MODE
-- tnoremap("<esc>", [[<C-\><C-n>]])
tnoremap("jj", [[<C-\><C-n>]])
tnoremap("<C-h>", [[<Cmd>wincmd h<CR>]]) -- Window navigation from terminal
tnoremap("<C-j>", [[<Cmd>wincmd j<CR>]]) -- Window navigation from terminal
tnoremap("<C-k>", [[<Cmd>wincmd k<CR>]]) -- Window navigation from terminal
tnoremap("<C-l>", [[<Cmd>wincmd l<CR>]]) -- Window navigation from terminal
-- tnoremap()
