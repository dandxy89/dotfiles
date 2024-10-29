return {
	{
		"dnlhc/glance.nvim",
        lazy = true,
		event = "InsertEnter",
		config = function()
			require("glance").setup({
				height = 23,
			})
		end,
	},
}
