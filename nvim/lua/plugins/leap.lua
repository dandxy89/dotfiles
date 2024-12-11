return {
	{
		"ggandor/leap.nvim",
		lazy = true,
        enabled = false,
		event = "InsertEnter",
		config = function()
			require("leap").create_default_mappings()
		end,
	},
}
