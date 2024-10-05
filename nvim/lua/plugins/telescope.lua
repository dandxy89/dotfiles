---@diagnostic disable: undefined-global
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "SalOrak/whaler" },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
					find_files = {
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--glob",
							"!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
							"--path-separator",
							"/",
						},
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set(
				"n",
				"<leader>f",
				"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
				{}
			)
			vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
		end,
		opts = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<Leader>fw", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end, { desc = "Search for word under cursor" })
			vim.keymap.set("n", "<Leader>few", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end, { desc = "Search for the exact word under cursor" })
			telescope.setup({
				defaults = {
					prompt_prefix = "󰼛 ",
					selection_caret = "󱞩 ",
				},
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				pickers = {
					lsp_references = {
						show_line = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					whaler = {
						directories = {
							"/Users/dandixey/.config/",
							"/Users/dandixey/Dan",
						},
						auto_file_explorer = false,
						auto_cwd = true,
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("whaler")
		end,
	},
	{
		"kelly-lin/ranger.nvim",
		event = "VeryLazy",
		config = function()
			require("ranger-nvim").setup({ replace_netrw = true })
			vim.api.nvim_set_keymap("n", "<leader>ef", "", {
				noremap = true,
				callback = function()
					require("ranger-nvim").open(true)
				end,
			})
		end,
	},
}
