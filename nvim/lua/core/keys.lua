---@diagnostic disable: undefined-global
local function bind(op, outer_opts)
	outer_opts = vim.tbl_extend("force", { noremap = true, silent = true, nowait = true }, outer_opts or {})

	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

local nnoremap = bind("n")
local vnoremap = bind("v")
-- local tnoremap = bind("t")

-- NORMAL MODE
nnoremap("<Leader>w", ":w<CR>") -- Faster Saving
nnoremap("<Space>", "Nop>") -- Nop Space bar
nnoremap("<Leader>lz", ":Lazy<CR>") -- Open Lazy
nnoremap("<Tab>", ":bNext<CR>") -- Next Buffer
nnoremap("<S-Tab>", ":bprevious<CR>") -- Previous Buffer
nnoremap("<Leader>d", ":bd! <CR>") -- Delete Buffer
nnoremap("<F5>", ":UndotreeToggle<CR>") -- Toggle UndoTree Plugin
nnoremap("<Leader>sr", ":vs<CR>") -- Split Right
nnoremap("<Leader>wh", ":wincmd h<CR>") -- Switch Window - Left
nnoremap("<Leader>wl", ":wincmd l<CR>") -- Switch Window - Right
nnoremap("<Leader>mt", ":terminal make test<CR>") -- Run Make Test
nnoremap("<Leader>gf", ":!black %<CR>") -- Run the Black formatter
nnoremap("<Leader>gfl", ":!stylua %<CR>") -- Run the Stylua formatter
nnoremap("<Leader>fj", ":%!jq .<CR>") -- Format Json
nnoremap("<Leader>=", ":vertical resize +10<CR>") -- Resize - thinner buffer
nnoremap("<Leader>-", ":vertical resize -10<CR>") -- Resize - widen buffer
nnoremap("<Leader>rh", ":nohl<CR>") -- Remove search highlighting
nnoremap("<F9>", ":!python %<CR>") -- Run Python Script in Buffer

nnoremap("<Leader>f", ":lua require('fzf-lua').files()<CR>") -- File list
nnoremap("<Leader>lg", ":lua require('fzf-lua').live_grep()<CR>") -- Live Grep
nnoremap("<Leader>bl", ":lua require('fzf-lua').buffers()<CR>") -- Buffer list
nnoremap("<Leader>di", ":lua require('fzf-lua').diagnostics_workspace({ fzf_opts = { ['--wrap'] = true }})<CR>")
nnoremap("<Leader>ca", ":lua require('fzf-lua').lsp_code_actions({ winopts = {relative='cursor',row=1.01, col=0, height=0.2, width=0.4} })<CR>")

nnoremap("<Leader>nn", ":lua require('quicknote').NewNoteAtCWD()<CR>")
nnoremap("<Leader>on", ":lua require('quicknote').OpenNoteAtCWD()<CR>")

nnoremap("<C-a>", "gg<S-v>G") -- Select all
nnoremap("x", '"_x') -- No map x

nnoremap("<Leader>nf", "<cmd>enew<cr>") -- New file
nnoremap("<Leader>ca", ":lua vim.lsp.buf.code_action()<CR>") -- Code Action
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
nnoremap("<Leader>tt", ":vnew term://zsh<CR>") -- Open Terminal
nnoremap("<Leader>gg", ":LazyGit<CR>") -- LazyGit Command Shell
nnoremap("<BS>", "<C-o>") -- Backspace Ctrl+O"
nnoremap("<F3>", ":lua vim.lsp.buf.rename()<CR>") -- Rename
nnoremap("K", ":lua vim.lsp.buf.hover()<CR>") -- Hover
nnoremap("<Leader>gd", ":lua vim.lsp.buf.declaration()<CR>") -- Declaration
nnoremap("<space>", "<Nop>") -- Disable Space bar since it'll be used as the leader key

vnoremap("<Tab>", ">gv") -- Tab/Shift+tab to indent/dedent
vnoremap("<S-Tab>", "<<") -- Tab/Shift+tab to indent/dedent
vnoremap("H", "_") -- H to go the start of line(n)
vnoremap("L", "$") -- L to go to the end of line(n)
vnoremap("K", ":m '>-2<CR>gv=gv") -- Move current line up
vnoremap("J", ":m '>+1<CR>gv=gv") -- Move current line down
vnoremap("<Leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace Selected
vnoremap("<space>", "<Nop>") -- Disable Space bar since it'll be used as the leader key
