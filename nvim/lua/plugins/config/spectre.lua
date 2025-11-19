require("spectre").setup({
    replace_engine = {
        ["sed"] = { cmd = "sed", args = { "-i", "", "-E" } },
    },
})

local function map(mode, key, cmd, desc)
    vim.keymap.set(mode, key, cmd, { noremap = true, silent = true, desc = desc })
end

map("n", "<Leader>S", '<cmd>lua require("spectre").toggle()<CR>', "Toggle Spectre")
map("n", "<Leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "Search current word")
map("v", "<Leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', "Search current word")
map("n", "<Leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', "Search on current file")

