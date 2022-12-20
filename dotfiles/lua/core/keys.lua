-- [[Code Folding]]
--  zf - create
--  zo - open
--  zc - Close
-- [[Spelling]]
--  [s ]s - find Spelling errors
--  zg - adds to local store
--  z= - offer Spelling suggestions
local opt = {
    noremap = true,
    nowait = true,
    silent = true
}

local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local arr = { -- Faster Saving
    { "<Leader>w", ":w<CR>" }, -- Start LSP
    { "<Leader>U", ":LspStart<CR>" }, -- Open Lazy
    { "<Leader>l", ":Lazy<CR>" }, -- Duplicate current line
    { "B", "yyp" }, -- Neotree Toggle
    { "<Leader>n", ":Neotree toggle<CR>" }, -- Tab New
    { "<Leader>nt", ":tabnew<CR>" }, -- Tab Close
    { "<Leader>ct", ":tabclose<CR>" }, -- Tab Previous
    { "<Leader>pt", ":tabprevious<CR>" }, -- Next Buffer
    { "<Leader>nb", ":bNext<CR>" }, -- Previous Buffer
    { "<Leader>pb", ":bprevious<CR>" }, -- Toggle UndoTree Plugin
    { "<F5>", ":UndotreeToggle<CR>" }, -- Split Right
    { "<Leader>sr", ":vs<CR>" }, -- Switch Window - Left
    { "<Leader>wh", ":wincmd h<CR>" }, -- Switch Window - Right
    { "<Leader>wl", ":wincmd l<CR>" }, -- Run Make Test
    { "<Leader>mt", ":terminal make test<CR>" }, -- Run the Black formatter
    { "<Leader>gf", ":!black %<CR>" }, -- Log into AWS
    { "<Leader>aws", ":vsplit<CR> :terminal saml2aws login -a woodmac-nonprod<CR>" }, -- Format Json
    { "<Leader>fj", ":%!jq .<CR>" }, -- Test Nearest
    { "<Leader>gt", ":TestNearest<CR>" }, -- Telescope: Git Status
    { "<Leader>gs", ":Telescope git_status<CR>" }, -- Telescope: Most Recently Used
    { "<Leader>ru", ":Telescope mru<CR>" }, -- Telescope: Open Telescope
    { "<Leader>ot", ":Telescope<CR>" }, -- Resize - thinner buffer
    { "<Leader>=", ":vertical resize +10<CR>" }, -- Resize - widen buffer
    { "<Leader>-", ":vertical resize -10<CR>" }, -- Remove search highlighting
    { "<Leader>nh", ":nohl<CR>" }, -- Run Python Script in Buffer
    { "<F9>", ":!python %<CR>" }, -- Find Files
    { "<Leader>f", ":Telescope find_files hidden=true<CR>" }, -- Edit Nvim Config
    { "<Leader>en", ":Telescope find_files cwd=~/.config/nvim<CR>" }, -- Live grep
    { "<Leader>lg", ":Telescope live_grep<CR>" }, -- LSP Workspace Symbols
    { "<leader>ws", ":Telescope lsp_workspace_symbols<CR>" }, -- Fuzzy Find in Current buffer
    { "<leader>ff", ":Telescope current_buffer_fuzzy_find<CR>" }, -- Document Symbols
    { "<leader>ds", ":Telescope lsp_document_symbols<CR>" } -- LSP Diagnostics
}

for k, v in pairs(arr) do
    map("n", v[1], v[2], opts)
end
