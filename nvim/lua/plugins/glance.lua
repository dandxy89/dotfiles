return {
	{
		"dnlhc/glance.nvim",
		keys = { "<Leader>u" },
		ft = { "pest", "rust", "python", "lua", "toml" },
		event = "InsertEnter",
		config = function()
			require("glance").setup({
				height = 23,
			})
		end,
	},
}
