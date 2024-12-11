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
	group = augroup("TextYankPostGrp"),
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

-- Create an async function to run pytest
local function run_pytest()
	-- Create a new terminal buffer
	vim.cmd("new")

	-- Get the terminal job ID
	local buf = vim.api.nvim_get_current_buf()

	-- Run pytest asynchronously
	local job_id = vim.fn.jobstart("pytest", {
		on_stdout = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
			end
		end,
		on_exit = function(_, code)
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "Pytest finished with exit code: " .. code })
		end,
		stdout_buffered = true,
		stderr_buffered = true,
	})

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") -- This ensures buffer is deleted when closed
	vim.api.nvim_buf_set_name(buf, "Pytest Output")
	vim.api.nvim_buf_set_option(buf, "filetype", "pytest-output")

	-- Add keymapping to close the buffer with 'q'
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":bdelete!<CR>", {
		noremap = true,
		silent = true,
		nowait = true,
	})

	-- Set buffer local options for easy closing
	vim.api.nvim_buf_set_option(buf, "buflisted", false)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Create a command to run pytest
vim.api.nvim_create_user_command("PyTest", run_pytest, {})

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
