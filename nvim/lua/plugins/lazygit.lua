return {
	{
		"kdheepak/lazygit.nvim",
		keys = { "<Leader>u" },
		ft = { "pest", "rust", "python", "lua", "toml" },
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true }
		},
	},
}
