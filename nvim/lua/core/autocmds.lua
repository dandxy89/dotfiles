---@diagnostic disable: undefined-global

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd(
	{ "FocusGained", "TermClose", "TermLeave" },
	{ command = "checktime", group = augroup("FocusGainedGrp") }
)

-- Strips unwanted trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
	group = augroup("FormatPreGrp"),
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = augroup("TextYankPostGrp")
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	group = augroup("ResizeGrp"),
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
	group = augroup("FormattingGrp"),
})

-- close some filetypes with <esc>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("CloseWithEscGrp"),
	pattern = {
		"PlenaryTestPopup",
		"grug-far",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"Lazy",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "<esc>", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})
