---@diagnostic disable: undefined-global

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Strips unwanted trailing whitespace
local format_sync_grp = vim.api.nvim_create_augroup("FormatPreWrt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
	group = format_sync_grp,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
