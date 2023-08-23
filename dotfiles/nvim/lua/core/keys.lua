-- [[Code Folding]]
--  zf - create
--  zo - open
--  zc - Close
--
-- [[Spelling]]
--  [s ]s - find Spelling errors
--  zg - adds to local store
--  z= - offer Spelling suggestions
--
-- [[quickref]]
-- https://quickref.me/vim
--

local function map(mode, lhs, rhs, desc)
  local options = {
    noremap = true,
    nowait = true,
    desc = desc,
  }
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change the cwd to the directory of the current active buffer.
function _cwd_current_buffer()
  -- map_key(n_v, "gc", "<Cmd>lua _cwd_current_buffer()<CR><Cmd>NvimTreeRefresh<CR>", default_settings)
  local abs_path = vim.api.nvim_buf_get_name(0)
  local dir = abs_path:match "(.*[/\\])"
  if dir == nil then
    return
  end
  vim.cmd("cd " .. dir)
end

local normal_mode = {
  { "<Leader>w",   ":w<CR>",                                             "Faster Saving" },
  { "<Leader>lz",  ":Lazy<CR>",                                          "Open Lazy" },
  -- { "B", "yyp", "Duplicate current line" },
  { "<Leader>nt",  ":tabnew<CR>",                                        "Tab New" },
  { "<Leader>ct",  ":tabclose<CR>",                                      "Tab Close" },
  { "<Leader>pt",  ":tabprevious<CR>",                                   "Tab Previous" },
  { "<Leader>nb",  ":bNext<CR>",                                         "Next Buffer" },
  { "<Leader>pb",  ":bprevious<CR>",                                     "Previous Buffer" },
  { "<F5>",        ":UndotreeToggle<CR>",                                "Toggle UndoTree Plugin" },
  { "<Leader>sr",  ":vs<CR>",                                            "Split Right" },
  { "<Leader>wh",  ":wincmd h<CR>",                                      "Switch Window - Left" },
  { "<Leader>wl",  ":wincmd l<CR>",                                      "Switch Window - Right" },
  { "<Leader>mt",  ":terminal make test<CR>",                            "Run Make Test" },
  { "<Leader>gf",  ":!black %<CR>",                                      "Run the Black formatter" },
  { "<Leader>gfl", ":!stylua %<CR>",                                     "Run the Stylua formatter" },
  { "<Leader>fj",  ":%!jq .<CR>",                                        "Format Json" },
  { "<Leader>gt",  ":TestNearest<CR>",                                   "Test Nearest" },
  { "<Leader>gs",  ":Telescope git_status<CR>",                          "Telescope: Git Status" },
  { "<Leader>ru",  ":Telescope mru<CR>",                                 "Telescope: Most Recently Used" },
  { "<Leader>ot",  ":Telescope<CR>",                                     "Telescope: Open Telescope" },
  { "<Leader>=",   ":vertical resize +10<CR>",                           "Resize - thinner buffer" },
  { "<Leader>-",   ":vertical resize -10<CR>",                           "Resize - widen buffer" },
  { "<Leader>rh",  ":nohl<CR>",                                          "Remove search highlighting" },
  { "<F9>",        ":!python %<CR>",                                     "Run Python Script in Buffer" },
  { "<Leader>f",   ":Telescope find_files hidden=true<CR>",              "Find Files" },
  { "<Leader>en",  ":Telescope find_files cwd=~/.config/nvim<CR>",       "Edit Nvim Config" },
  { "<Leader>lg",  ":Telescope live_grep<CR>",                           "Live grep" },
  { "<leader>ws",  ":Telescope lsp_workspace_symbols<CR>",               "LSP Workspace Symbols" },
  { "<leader>ff",  ":Telescope current_buffer_fuzzy_find<CR>",           "Fuzzy Find in Current buffer" },
  { "<leader>ds",  ":Telescope lsp_document_symbols<CR>",                "Document Symbols" },
  { "<leader>di",  ":Telescope diagnostics<CR>",                         "LSP Diagnostics" },
  { "<C-a>",       "gg<S-v>G",                                           "Select all" },
  { "x",           '"_x',                                                "No map x" },
  { "qm",          ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "Harpoon: view all project marks with" },
  { "qj",          ":lua require('harpoon.ui').nav_next()<CR>",          "Harpoon: navigates to next mark" },
  { "qk",          ":lua require('harpoon.ui').nav_prev()<CR>",          "Harpoon: navigates to previous mark" },
  { "qh",          ":lua require('harpoon.mark').add_file()<CR>",        "Harpoon: add a file" },
  { "<leader>nf",  "<cmd>enew<cr>",                                      "New file" },
  { "<Tab>",       "v><C-\\><C-N>",                                      "Tab/Shift+tab to indent/dedent" },
  { "<leader>fp",  ":SearchReplaceSingleBufferOpen<CR>",                 "Find & Replace" },
  { "<leader>tm",  ":vnew term://zsh<cr>",                               "Open ZSH Terminal" },
  { "<leader>nl",  ":lua require('noice').cmd('last')<CR>",              "Noice Last" },
  { "<leader>nh",  ":lua require('noice').cmd('history')<CR>",           "Noice History" },
  { "<leader>ca",  ":lua vim.lsp.buf.code_action()<CR>",                 "Code Action" },
  { "H",           "_",                                                  "H to go the start of line(n)" },
  { "L",           "$",                                                  "L to go to the end of line(n)" },
  { "J",           "}",                                                  "J to jump previous blocks(n)" },
  { "K",           "{",                                                  "L to jump next blocks(n)" },
  { "<C-Z>",       "<Cmd>undo<CR>",                                      "Undo" },
  { "<C-Y>",       "<Cmd>redo<CR>",                                      "Redo" },
  { "<Leader>fl",  ":lua vim.lsp.buf.format",                            "Format Code" },
  { "gR",          ":Glance references<CR>",                             "Show references" },
  { "gD",          ":Glance definitions<CR>",                            "Show definitions" },
  { "gM",          ":Glance implementations<CR>",                        "Show implementations" },
  -- { "", "", ""},
}

for _, v in pairs(normal_mode) do
  map("n", v[1], v[2])
end

local visual_mode = {
  { "<Tab>", ">gv", "Tab/Shift+tab to indent/dedent" },
  { "H",     "_",   "H to go the start of line(n)" },
  { "L",     "$",   "L to go to the end of line(n)" },
  { "J",     "}",   "J to jump previous blocks(n)" },
  { "K",     "{",   "L to jump next blocks(n)" },
}

for _, v in pairs(visual_mode) do
  map("v", v[1], v[2])
end