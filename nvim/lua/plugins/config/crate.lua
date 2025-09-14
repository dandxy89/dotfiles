vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Cargo.toml",
    callback = function()
        require("crates").setup()
    end,
})
