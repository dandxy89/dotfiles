return {
    {
        -- use ydaw to duplicate the current word (including whitespace)
        -- 3ydd to duplicate the next three lines.
        -- yd in normal mode
        "smjonas/duplicate.nvim",
        event = "VeryLazy",
        config = function()
            require("duplicate").setup()
        end
    },
}
