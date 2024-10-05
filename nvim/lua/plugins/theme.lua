---@diagnostic disable: undefined-global
return {
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("github-theme").setup({})
	-- 		vim.cmd.colorscheme("github_dark_colorblind")
	-- 	end,
	-- },
	{
		"HoNamDuong/hybrid.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd("colorscheme hybrid")
		end
	}
}
