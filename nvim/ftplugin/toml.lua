if vim.fn.expand("%:t"):match("^Cargo") then require("crates").setup({}) end
