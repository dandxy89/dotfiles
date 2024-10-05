return {
	{
		"ggandor/leap.nvim",
		ft = { "pest", "rust", "python", "lua", "toml" },
		config = function()
			require("leap").create_default_mappings()
		end,
	},
}
