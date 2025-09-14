require("spectre").setup({
    replace_engine = {
        ["sed"] = { cmd = "sed", args = { "-i", "", "-E" } },
    },
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>S", '<cmd>lua require("spectre").toggle()<CR>',
    vim.tbl_extend("force", opts, { desc = "Toggle Spectre" }))
vim.keymap.set("n", "<Leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    vim.tbl_extend("force", opts, { desc = "Search current word" }))
vim.keymap.set("v", "<Leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>',
    vim.tbl_extend("force", opts, { desc = "Search current word" }))
vim.keymap.set("n", "<Leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    vim.tbl_extend("force", opts, { desc = "Search on current file" }))

