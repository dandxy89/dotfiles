require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "cmake", "dockerfile", "hcl", "help", "http", "json", "lua", "make", "markdown",
                        "python", "regex", "rust", "toml", "vim", "yaml"},
    auto_install = true,
    highlight = {
        enable = true
    },
    ident = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil
    }
}
