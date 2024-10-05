return {
	{
		"echasnovski/mini.comment",
		version = false,
		keys = { "<Leader>u" },
		ft = { "pest", "rust", "python", "lua", "toml" },
		config = function()
			require("mini.comment").setup()
		end,
	},
}
