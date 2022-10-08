--[[ keys.lua ]]
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
vim.g.mapleader = " "

-- Update Plugins
map("n", "<Leader>u", ":PackerSync<CR>")

-- NERDTree
map("n", "<Leader>n", ":NERDTreeToggle<CR>")

-- Tab Previous
map("n", "<Leader>p", ":tabprevious<CR>")

-- Previous Buffer
map("n", "<Leader>bp", ":bprevious<CR>")

-- Toggle UndoTree Plugin
map("n", "<F5>", ":UndotreeToggle<CR>")

-- Split Right
map("n", "<Leader>jj", ":vsplit<CR>")

-- Run Make Test
map("n", "<Leader>mt", ":terminal make test<CR>")

-- Run Test Calculate Cost om GGM (TEMP)
map("n", "<Leader>tcc", ":vsplit<CR> :terminal poetry run pytest tests/unit_tests/Preprocessing/test_CalculateCosts.py<CR>")

-- Run Pre-Commit in C2MD
map("n", "<Leader>pcc", ":vsplit<CR> :terminal cd ~/Python/c2md-rulesengine && make run_pre_commit<CR>")

-- Log into AWS
map("n", "<Leader>aws", ":vsplit<CR> :terminal saml2aws login -a woodmac-nonprod<CR>")

local km = vim.keymap

-- Harpoon Mark
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

-- Code Action
km.set("n", "<leader>ga", function()
  vim.lsp.buf.code_action()
end)

-- LSP Symbols
km.set("n", "<leader>gs", function()
  require("telescope.builtin").lsp_document_symbols()
end)

-- LSP Diagnostics
km.set("n", "<leader>td", function()
  require("telescope.builtin").diagnostics()
end)

-- LSP References
km.set("n", "<leader>gr", function()
  require("telescope.builtin").lsp_references()
end)

-- LSP Rename
km.set({ "v", "n" }, "<leader>cn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true })

-- LSP Definition
km.set("n", "<leader>gd", function()
  vim.lsp.buf.definition()
end)

-- LSP Sig Show
km.set("n", "<leader>sh", function()
  vim.lsp.buf.signature_help()
end)

-- LSP Hover
km.set("n", "<leader>hh", function()
  vim.lsp.buf.hover()
end)
