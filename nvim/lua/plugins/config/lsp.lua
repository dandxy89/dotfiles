require('nvim-biscuits').setup({})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Cargo.toml",
    callback = function()
        require("crates").setup()
    end,
})

vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

local servers = {}
local lsp_servers_path = vim.fn.stdpath("config") .. "/lsp"

for file in vim.fs.dir(lsp_servers_path) do
    local name = file:match("(.+)%.lua$")
    if name then
        servers[name] = true
        vim.lsp.enable(name)
    end
end

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers or {}),
})

vim.diagnostic.config({
    signs = {
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        },
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.WARN] = "",
        },
    },
    update_in_insert = true,
    virtual_text = true,
    underline = true,
    severity_sort = true,
})

local icons = {
    Class = " ", Color = " ", Constant = " ", Constructor = " ", Enum = " ",
    EnumMember = " ", Event = " ", Field = " ", File = " ", Folder = " ",
    Function = "󰊕 ", Interface = " ", Keyword = " ", Method = "ƒ ", Module = "󰏗 ",
    Property = " ", Snippet = " ", Struct = " ", Text = " ", Unit = " ",
    Value = " ", Variable = " ",
}

local completion_kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(completion_kinds) do
    completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
end
