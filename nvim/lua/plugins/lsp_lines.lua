return {
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("lsp_lines").setup()
		end,
	},
	{
		"RutaTang/quicknote.nvim",
		config = function()
			require("quicknote").setup({})
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
