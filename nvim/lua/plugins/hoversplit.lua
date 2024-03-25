--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Flying Saucer                      ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "roobert/hoversplit.nvim",
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "toml" },
        config = function()
            require("hoversplit").setup({
                key_bindings = {
                    split_remain_focused = "<Leader>hs",
                    vsplit_remain_focused = "<Leader>hv",
                    split = "<Leader>hS",
                    vsplit = "<Leader>hV",
                },
            })
        end,
    },
}
