-- If the file is a Cargo toml file then init the 'crates'
if vim.fn.expand("%:t"):match("^Cargo") then
    require("crates").setup({})
end
