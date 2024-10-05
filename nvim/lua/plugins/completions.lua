return {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "RRethy/vim-illuminate" },
	{ "hrsh7th/cmp-omni" },
	{ "lukas-reineke/cmp-rg" },
	{ "vxpm/ferris.nvim" },
	{ "m-demare/hlargs.nvim" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local luasnip = require("luasnip")
			-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			cmp.setup({
				preselect = cmp.PreselectMode.Item,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
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
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "hrsh7th/cmp-omni" },
					{ name = "RRethy/vim-illuminate" },
					{ name = "lukas-reineke/cmp-rg" },
					{ name = "vxpm/ferris.nvim" },
					{ name = "m-demare/hlargs.nvim" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
