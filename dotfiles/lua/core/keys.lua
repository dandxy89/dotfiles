-- [[ keys.lua ]]
local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- [[ Update Plugins ]]
map("n", "<Leader>u", ":PackerSync<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- -- Duplicate current line
map("n", "B", "yyp", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Faster Saving
map("n", "<Leader>w", ":w<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Neotree Toggle
map("n", "<Leader>n", ":Neotree toggle<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Tab New
map("n", "<Leader>nt", ":tabnew<CR>", {
    noremap = true,
    nowait = true
})

-- Tab Close
map("n", "<Leader>ct", ":tabclose<CR>", {
    noremap = true,
    nowait = true
})

-- Tab Previous
map("n", "<Leader>pt", ":tabprevious<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Next Buffer
map("n", "<Leader>nb", ":bNext<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Previous Buffer
map("n", "<Leader>pb", ":bprevious<CR>", {
    noremap = true,
    nowait = true
})

-- Toggle UndoTree Plugin
map("n", "<F5>", ":UndotreeToggle<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Split Right
map("n", "<Leader>sr", ":vs<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Switch Window - Left
map("n", "<Leader>wh", ":wincmd h<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Switch Window - Right
map("n", "<Leader>wl", ":wincmd l<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Run Make Test
map("n", "<Leader>mt", ":terminal make test<CR>", {
    noremap = true,
    nowait = true
})

-- Run the Black formatter
map("", "<Leader>gf", ":!black %<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Log into AWS
map("n", "<Leader>aws", ":vsplit<CR> :terminal saml2aws login -a woodmac-nonprod<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Format Json
map("n", "<Leader>fj", ":%!jq .<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Test Nearest
map("n", "<Leader>gt", ":TestNearest<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Git Status
map("n", "<Leader>gs", ":Telescope git_status<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

map("n", "<Leader>ru", ":Telescope mru<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Open Telescope
map("n", "<Leader>ot", ":Telescope<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Resize - thinner buffer
map("n", "<Leader>=", ":vertical resize +10<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Resize - widen buffer
map("n", "<Leader>-", ":vertical resize -10<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Remove search highlighting
map("n", "<Leader>nh", ":nohl<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

-- Remove search highlighting
map("n", "<Leader>nh", ":nohl<CR>", {
    noremap = true,
    nowait = true,
    silent = true
})

local km = vim.keymap

-- Edit Nvim Config
km.set("n", "<Leader>en", function()
    require("telescope.builtin").find_files({
        cwd = "~/.config/nvim"
    })
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Find Files
km.set("n", "<Leader>f", function()
    require("telescope.builtin").find_files()
end)

-- Live grep
km.set("n", "<Leader>lg", function()
    require("telescope.builtin").live_grep()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

km.set("n", "<leader>ws", function()
    require("telescope.builtin").lsp_workspace_symbols()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Fuzzy Find in Current buffer
km.set("n", "<leader>ff", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Document Symbols
km.set("n", "<leader>ds", function()
    require("telescope.builtin").lsp_document_symbols()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Diagnostics
km.set("n", "<leader>wi", function()
    require("telescope.builtin").diagnostics()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Code folding
--  zf - create
--  zo - open
--  zc - Close

-- Spelling
--  [s ]s - find Spelling errors
--  zg - adds to local store
--  z= - offer Spelling suggestions
