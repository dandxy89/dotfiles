return {
	{
		"echasnovski/mini.comment",
		version = false,
		event = "InsertEnter",
		config = function()
			require("mini.comment").setup()
		end,
	},
}
