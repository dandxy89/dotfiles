local parsers = {
    "bash", "lua", "rust", "python", "typescript",
    "javascript", "json", "yaml", "toml", "markdown", "vim"
}

for _, parser in ipairs(parsers) do
    pcall(function()
        vim.cmd("TSInstall " .. parser)
    end)
end

print("Treesitter parsers installation complete")
