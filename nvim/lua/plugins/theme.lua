---@diagnostic disable: undefined-global
return {
	{
		"HoNamDuong/hybrid.nvim",
		lazy = false,
		priority = 1010,
		opts = {},
		config = function()
			vim.cmd("colorscheme hybrid")
		end
	}
}
