--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Key Maps                           ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

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
local function map(mode, lhs, rhs, desc)
    local options = {
        noremap = true,
        nowait = true,
        desc = desc,
    }
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Open Telescope. If in a git repo, use git_files, otherwise use find_files
function OpenTelescope()
    if os.execute('git rev-parse --is-inside-work-tree 2> /dev/null') == 0 then
        require('telescope.builtin').git_files()
    else
        require('telescope.builtin').find_files()
    end
end

local normal_mode = {
    -- Saving
    { "<Leader>w",     ":w<CR>",                                                  "Faster Saving" },
    -- netrw
    { "<Leader>n",     ":15Lex<CR>",                                              "Netrw" },
    -- Lazy
    { "<Leader>lz",    ":Lazy<CR>",                                               "Open Lazy" },
    -- Buffer Nav
    { "<Tab>",         ":bNext<CR>",                                              "Next Buffer" },
    { "<S-Tab>",       ":bprevious<CR>",                                          "Previous Buffer" },
    { "<Leader>d",     ":bd! <CR>",                                               "Delete Buffer" },
    -- Undo
    { "<F5>",          ":UndotreeToggle<CR>",                                     "Toggle UndoTree Plugin" },
    -- Splitting
    { "<Leader>sr",    ":vs<CR>",                                                 "Split Right" },
    { "<Leader>wh",    ":wincmd h<CR>",                                           "Switch Window - Left" },
    { "<Leader>wl",    ":wincmd l<CR>",                                           "Switch Window - Right" },
    -- Makefile
    { "<Leader>mt",    ":terminal make test<CR>",                                 "Run Make Test" },
    -- Formatting
    { "<Leader>gf",    ":!black %<CR>",                                           "Run the Black formatter" },
    { "<Leader>gfl",   ":!stylua %<CR>",                                          "Run the Stylua formatter" },
    { "<Leader>fj",    ":%!jq .<CR>",                                             "Format Json" },
    -- Resizing
    { "<Leader>=",     ":vertical resize +10<CR>",                                "Resize - thinner buffer" },
    { "<Leader>-",     ":vertical resize -10<CR>",                                "Resize - widen buffer" },
    -- Highlights
    { "<Leader>rh",    ":nohl<CR>",                                               "Remove search highlighting" },
    -- Python exec
    { "<F9>",          ":!python %<CR>",                                          "Run Python Script in Buffer" },
    -- Telescope
    { "<Leader>gs",    ":Telescope git_status<CR>",                               "Telescope: Git Status" },
    { "<Leader>op",    ":Telescope whaler<CR>",                                   "Known Projects" },
    { "<Leader>f",     function() OpenTelescope() end,                            "Find Files" },
    { "<Leader>nc",    ":Telescope find_files cwd=~/.config/nvim<CR>",            "Edit Nvim Config" },
    { "<Leader>lg",    ":Telescope live_grep<CR>",                                "Live grep" },
    { "<Leader>bl",    ":Telescope buffers<CR>",                                  "Buffer list" },
    { "<Leader>ws",    ":Telescope lsp_workspace_symbols<CR>",                    "LSP Workspace Symbols" },
    { "<Leader>ds",    ":Telescope lsp_document_symbols<CR>",                     "Document Symbols" },
    { "<Leader>di",    ":Telescope diagnostics<CR>",                              "LSP Diagnostics" },
    { "<Leader><tab>", "<Cmd>lua require('telescope.builtin').commands()<CR>",    "Options in Telescope" },
    -- Select all
    { "<C-a>",         "gg<S-v>G",                                                "Select all" },
    -- Noop
    { "x",             '"_x',                                                     "No map x" },
    -- New file
    { "<Leader>nf",    "<cmd>enew<cr>",                                           "New file" },
    -- Noice
    { "<Leader>nl",    ":lua require('noice').cmd('last')<CR>",                   "Noice Last" },
    { "<Leader>nh",    ":lua require('noice').cmd('history')<CR>",                "Noice History" },
    { "<Leader>ca",    ":lua vim.lsp.buf.code_action()<CR>",                      "Code Action" },
    -- Hmm
    { "H",             "_",                                                       "H to go the start of line(n)" },
    { "L",             "$",                                                       "L to go to the end of line(n)" },
    -- { "K",             "{",                                                       "K to jump previous blocks(n)" },
    { "J",             "}",                                                       "J to jump previous blocks(n)" },
    -- Undo
    { "<C-Z>",         "<Cmd>undo<CR>",                                           "Undo" },
    { "<C-Y>",         "<Cmd>redo<CR>",                                           "Redo" },
    -- LSP format
    { "<Leader>fl",    ":lua vim.lsp.buf.format()<CR>",                           "Format Code" },
    -- Glance
    { "gR",            ":Glance references<CR>",                                  "Show references" },
    { "gD",            ":Glance definitions<CR>",                                 "Show definitions" },
    { "gM",            ":Glance implementations<CR>",                             "Show implementations" },
    { "gY",            ":Glance type_definitions<CR>",                            "Show type definitions" },
    -- LSP diagnostics
    { "<Leader>e",     ":lua vim.diagnostic.open_float()<CR>",                    "Open Diagnostics Float" },
    -- Terminal
    { "<Leader>tt",    ":vnew term://zsh<CR>",                                    "Open Terminal" },
    -- Executor && Neotest
    -- { "<Leader>eo",    ":ExecutorRun <CR>",                                       "Run Executor" },
    -- { "<Leader>ta",    ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Run tests in file" },
    -- { "<Leader>tn",    ":lua require('neotest').run.run()<CR>",                   "Run nearest test" },
    -- { "<Leader>to",    ":lua require('neotest').output.open({enter=false})<CR>",  "Show Neotest output" },
    -- LazyGit
    { "<Leader>gg",    ":LazyGit<CR>",                                            "LazyGit Command Shell" },
}

for _, v in pairs(normal_mode) do
    map("n", v[1], v[2])
end

local visual_mode = {
    -- Indentation
    { "<Tab>",     ">gv",                           "Tab/Shift+tab to indent/dedent" },
    { "<S-Tab>",   "<<",                            "Tab/Shift+tab to indent/dedent" },
    -- Navigation
    { "H",         "_",                             "H to go the start of line(n)" },
    { "L",         "$",                             "L to go to the end of line(n)" },
    { "J",         ":m '>+1<CR>gv=gv",              "J to jump previous blocks(n)" }, -- Move current line down
    { "K",         ":m '>-2<CR>gv=gv",              "L to jump next blocks(n)" },     -- Move current line up
    -- Replace
    { "<Leader>r", "\"hy:%s/<C-r>h//g<left><left>", "Replace Selected" },
}

for _, v in pairs(visual_mode) do
    map("v", v[1], v[2])
end

-- Useful links:
--  1. https://vim.fandom.com/wiki/Search_and_replace_in_a_visual_selection
--  2. https://quickref.me/vim
--
