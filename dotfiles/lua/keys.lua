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

-- Update Plugins
map("n", "<Leader>u", ":PackerSync<CR>")
-- Faster Saving
map("n", "<Leader>w", ":w<CR>")
-- Neotree Toggle
map("n", "<Leader>n", ":Neotree toggle<CR>")
-- Neotree Buffers
map("n", "<Leader>nb", ":Neotree buffers<CR>")
-- Tab New
map("n", "<Leader>tn", ":tabnew<CR>")
-- Tab Close
map("n", "<Leader>tc", ":tabclose<CR>")
-- Tab Previous
map("n", "<Leader>pt", ":tabprevious<CR>")
-- Next Buffer
map("n", "<Leader>bn", ":bNext<CR>")
-- Previous Buffer
map("n", "<Leader>bp", ":bprevious<CR>")
-- Toggle UndoTree Plugin
map("n", "<F5>", ":UndotreeToggle<CR>")
-- Split Right
map("n", "<Leader>sr", ":vs<CR>")
-- Switch Window - Left
map("n", "<Leader>wh", ":wincmd h<CR>")
-- Switch Window - Right
map("n", "<Leader>wl", ":wincmd l<CR>")
-- Run Make Test
map("n", "<Leader>mt", ":terminal make test<CR>")
-- Run the Black formatter
map("", "<Leader>gf", ":!black %<CR>")
-- Run Pre-Commit in C2MD
map("n", "<Leader>rpc", ":vsplit<CR> :terminal make run_pre_commit<CR>")
-- Log into AWS
map("n", "<Leader>aws", ":vsplit<CR> :terminal saml2aws login -a woodmac-nonprod<CR>")
-- Format Json
map("n", "<Leader>fj", ":%!jq .<CR>")
-- Test Nearest
map("n", "<Leader>gt", ":TestNearest<CR>")
-- Git Status
map("n", "<Leader>gs", ":Telescope git_status<CR>")
-- Open Telescope
map("n", "<Leader>ot", ":Telescope<CR>")
-- Resize - thinner buffer
map("n", "<Leader>=", ":vertical resize +10<CR>")
-- Resize - widen buffer
map("n", "<Leader>-", ":vertical resize -10<CR>")
-- Remove search highlighting
map("n", "<Leader>nh", ":nohl<CR>")

local km = vim.keymap

-- Edit Nvim Config
km.set("n", "<Leader>en", function()
    require("telescope.builtin").find_files({
        cwd = "~/.config/nvim"
    })
end)
-- Harpoon Add File
km.set("n", "<F7>", function()
    require("harpoon.mark").add_file()
end)
-- Harpoon Menu
km.set("n", "<F8>", function()
    require("harpoon.ui").toggle_quick_menu()
end)
-- Harpoon Cycle Next
km.set("n", "<F9>", function()
    require("harpoon.ui").nav_next()
end)
-- Find Files
km.set("n", "<Leader>f", function()
    require("telescope.builtin").find_files()
end)
-- Live grep
km.set("n", "<Leader>lg", function()
    require("telescope.builtin").live_grep()
end)
-- Code Action
km.set("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
end)
-- LSP Symbols
km.set("n", "<leader>ds", function()
    require("telescope.builtin").lsp_document_symbols()
end)
km.set("n", "<leader>ws", function()
    require("telescope.builtin").lsp_workspace_symbols()
end)
-- LSP Diagnostics
km.set("n", "<leader>di", function()
    require("telescope.builtin").diagnostics()
end)
-- LSP References
km.set("n", "<leader>gr", function()
    require("telescope.builtin").lsp_references()
end)
-- LSP Rename
km.set({"v", "n"}, "<leader>rn", function()
    vim.lsp.buf.rename()
end, {
    noremap = true,
    silent = true
})
-- LSP Definition
km.set("n", "<leader>gd", function()
    vim.lsp.buf.definition()
end)
-- LSP Implementation
km.set("n", "<leader>gi", function()
    vim.lsp.buf.implementation()
end)
-- LSP Sig Show
km.set("n", "<leader>sh", function()
    vim.lsp.buf.signature_help()
end)
-- LSP Hover
km.set("n", "<leader>gh", function()
    vim.lsp.buf.hover()
end)

-- Code folding
--  zf - create
--  zo - open
--  zc - Close

-- Spelling
--  [s ]s - find Spelling errors
--  zg - adds to local store
--  z= - offer Spelling suggestions
