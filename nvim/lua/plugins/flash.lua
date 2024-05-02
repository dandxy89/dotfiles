--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Quick Nav                          ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "ggandor/leap.nvim",
        ft = { "pest", "rust", "python", "lua", "toml" },
        config = function()
            require('leap').create_default_mappings()
        end,
    },
    -- {
    --     "folke/flash.nvim",
    --     ft = { "pest", "rust", "python", "lua", "toml" },
    --     opts = {},
    --     -- stylua: ignore
    --     keys = {
    --         {
    --             "s",
    --             mode = { "n", "x", "o" },
    --             function()
    --                 require("flash").jump({
    --                     search = {
    --                         mode = function(str)
    --                             return "\\<" .. str
    --                         end,
    --                     },
    --                 })
    --             end,
    --             desc = "Flash",
    --         },
    --         {
    --             "r",
    --             mode = "o",
    --             function()
    --                 require("flash").remote()
    --             end,
    --             desc = "Remote Flash",
    --         },
    --         {
    --             "R",
    --             mode = { "o", "x" },
    --             function()
    --                 require("flash").treesitter_search()
    --             end,
    --             desc = "Flash Treesitter Search",
    --         },
    --         {
    --             "<c-s>",
    --             mode = { "c" },
    --             function()
    --                 require("flash").toggle()
    --             end,
    --             desc = "Toggle Flash Search",
    --         },
    --     },
    -- },
}
