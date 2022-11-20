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
    nowait = true
})

-- Faster Saving
map("n", "<Leader>w", ":w<CR>", {
    noremap = true,
    nowait = true
})

-- Neotree Toggle
map("n", "<Leader>n", ":Neotree toggle<CR>", {
    noremap = true,
    nowait = true
})

-- Neotree Buffers
map("n", "<Leader>nb", ":Neotree buffers<CR>", {
    noremap = true,
    nowait = true
})

-- Tab New
map("n", "<Leader>tn", ":tabnew<CR>", {
    noremap = true,
    nowait = true
})

-- Tab Close
map("n", "<Leader>tc", ":tabclose<CR>", {
    noremap = true,
    nowait = true
})

-- Tab Previous
map("n", "<Leader>pt", ":tabprevious<CR>", {
    noremap = true,
    nowait = true
})

-- Next Buffer
map("n", "<Leader>bn", ":bNext<CR>", {
    noremap = true,
    nowait = true
})

-- Previous Buffer
map("n", "<Leader>bp", ":bprevious<CR>", {
    noremap = true,
    nowait = true
})

-- Toggle UndoTree Plugin
map("n", "<F5>", ":UndotreeToggle<CR>", {
    noremap = true,
    nowait = true
})

-- Split Right
map("n", "<Leader>sr", ":vs<CR>", {
    noremap = true,
    nowait = true
})

-- Switch Window - Left
map("n", "<Leader>wh", ":wincmd h<CR>", {
    noremap = true,
    nowait = true
})

-- Switch Window - Right
map("n", "<Leader>wl", ":wincmd l<CR>", {
    noremap = true,
    nowait = true
})

-- Run Make Test
map("n", "<Leader>mt", ":terminal make test<CR>", {
    noremap = true,
    nowait = true
})

-- Run the Black formatter
map("", "<Leader>gf", ":!black %<CR>", {
    noremap = true,
    nowait = true
})

-- Run Pre-Commit in C2MD
map("n", "<Leader>rpc", ":vsplit<CR> :terminal make run_pre_commit<CR>", {
    noremap = true,
    nowait = true
})

-- Log into AWS
map("n", "<Leader>aws", ":vsplit<CR> :terminal saml2aws login -a woodmac-nonprod<CR>", {
    noremap = true,
    nowait = true
})

-- Format Json
map("n", "<Leader>fj", ":%!jq .<CR>", {
    noremap = true,
    nowait = true
})

-- Test Nearest
map("n", "<Leader>gt", ":TestNearest<CR>", {
    noremap = true,
    nowait = true
})

-- Git Status
map("n", "<Leader>gs", ":Telescope git_status<CR>", {
    noremap = true,
    nowait = true
})

-- Telescope Harpoon
map("n", "<Leader>hm", ":Telescope marks<CR>", {
    noremap = true,
    nowait = true
})

-- Open Telescope
map("n", "<Leader>ot", ":Telescope<CR>", {
    noremap = true,
    nowait = true
})

-- Resize - thinner buffer
map("n", "<Leader>=", ":vertical resize +10<CR>", {
    noremap = true,
    nowait = true
})

-- Resize - widen buffer
map("n", "<Leader>-", ":vertical resize -10<CR>", {
    noremap = true,
    nowait = true
})

-- Remove search highlighting
map("n", "<Leader>nh", ":nohl<CR>", {
    noremap = true,
    nowait = true
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

-- Harpoon Add File
km.set("n", "<F7>", function()
    require("harpoon.mark").add_file()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Harpoon Menu
km.set("n", "<F8>", function()
    require("harpoon.ui").toggle_quick_menu()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Harpoon Cycle Next
km.set("n", "<F9>", function()
    require("harpoon.ui").nav_next()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Find Files
km.set("n", "<Leader>f", function()
    require("telescope.builtin").find_files()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Live grep
km.set("n", "<Leader>lg", function()
    require("telescope.builtin").live_grep()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- Code Action
km.set("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Symbols
km.set("n", "<leader>ds", function()
    require("telescope.builtin").lsp_document_symbols()
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

-- LSP Diagnostics
km.set("n", "<leader>wi", function()
    require("telescope.builtin").diagnostics()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Diagnostics for Buffer
km.set("n", "<leader>di", function()
    require("telescope.builtin").diagnostics({
        bufnr = 0
    })
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP References
km.set("n", "<leader>gr", function()
    require("telescope.builtin").lsp_references()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Rename
km.set({"v", "n"}, "<leader>rn", function()
    vim.lsp.buf.rename()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Definition
km.set("n", "<leader>gd", function()
    vim.lsp.buf.definition()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Implementation
km.set("n", "<leader>gi", function()
    vim.lsp.buf.implementation()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Sig Show
km.set("n", "<leader>sh", function()
    vim.lsp.buf.signature_help()
end, {
    noremap = true,
    silent = true,
    nowait = true
})

-- LSP Hover
km.set("n", "<leader>gh", function()
    vim.lsp.buf.hover()
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
