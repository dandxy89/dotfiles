return {
	{
		"L3MON4D3/LuaSnip",
        lazy = true,
        event = "InsertEnter",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
        lazy = true,
        event = "InsertEnter",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "iguanacucumber/mag-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "RRethy/vim-illuminate" },
			{ "hrsh7th/cmp-omni" },
			{ "lukas-reineke/cmp-rg" },
			{ "vxpm/ferris.nvim" },
			{ "m-demare/hlargs.nvim" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/nvim-cmp" },
			{ "iguanacucumber/mag-buffer" },
			{ "ray-x/cmp-treesitter" },
			{ "pest-parser/pest.vim", ft = "pest" },
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			require("hlargs").setup()
			cmp.setup({
				preselect = cmp.PreselectMode.Item,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				matching = {
					disallow_fuzzy_matching = true,
					disallow_fullfuzzy_matching = true,
					disallow_partial_fuzzy_matching = true,
					disallow_partial_matching = false,
					disallow_prefix_unmatching = true,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				completion = {
					keyword_length = 1,
					completeopt = "menu,noselect,noinsert",
				},
				sources = cmp.config.sources({
					{ name = "vim-illuminate" },
					{ name = "cmp-rg" },
					{ name = "path" },
					{ name = "cmdline" },
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "omni", option = { disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" } } },
					{ name = "treesitter" },
					{ name = "nvim_lsp_signature_help" },
				}),
			})
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
