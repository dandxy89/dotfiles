return {
	{
		"saecki/crates.nvim",
        lazy = true,
		event = { "BufRead Cargo.toml" },
		requires = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		config = function()
			require("crates").setup({})
		end,
	},
}
