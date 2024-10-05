---@diagnostic disable: lowercase-global
return {
	{
		"j-hui/fidget.nvim",
		tag = "v1.0.0",
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"pylsp",
					"yamlls",
					"jsonls",
					"zls",
					"marksman",
					"harper_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.zls.setup({
				capabilities = capabilities,
				cmd = { "zls" },
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilties = capabilities,
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"html",
				},
			})
			lspconfig.eslint.setup({
				capabilties = capabilities,
			})
			require("lspconfig").clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--pch-storage=memory",
					"--all-scopes-completion",
					"--pretty",
					"--header-insertion=never",
					"-j=4",
					"--inlay-hints",
					"--header-insertion-decorators",
					"--function-arg-placeholders",
					"--completion-style=detailed",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = require("lspconfig").util.root_pattern("src"),
				init_option = { fallbackFlags = { "-std=c++2a" } },
				capabilities = capabilities,
			})
			lspconfig.pylsp.setup({
				capabilties = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pylsp_mypy = { enabled = false },
							mccabe = { enabled = false },
							rope = { enabled = false },
							pycodestyle = { enabled = false },
							pyflakes = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							pylint = { enabled = false },
							ruff = { enabled = true },
							jedi_completion = { fuzzy = true },
							black = { enabled = true },
							ipyls_isort = { enabled = true },
							rope_autoimport = { enabled = true },
						},
					},
					telemetry = {
						enable = false,
					},
				},
			})
			lspconfig.ruff.setup({
				capabilties = capabilities,
				settings = {
					organizeImports = false,
				},
			})
			lspconfig.rust_analyzer.setup({
				capabilties = capabilities,
				settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
							buildScripts = {
								enable = true,
							},
						},
						assist = {
							importEnforceGranularity = true,
							importPrefix = "crate",
							emitMustUse = true,
						},
						checkOnSave = {
							command = "check",
						},
						diagnostics = {
							enable = true,
						},
						inlayHints = {
							enable = false,
							locationLinks = false,
							parameter_hints_prefix = "  <-  ",
							other_hints_prefix = "  =>  ",
							highlight = "LspCodeLens",
							lifetimeElisionHints = {
								enable = false,
								useParameterNames = true,
							},
						},
						lens = {
							enable = true,
							methodReferences = true,
							references = true,
							implementations = false,
						},
						interpret = {
							tests = true,
						},
						rustfmt = {
							overrideCommand = "cargo +nightly fmt",
						},
						procMacro = {
							enable = true,
						},
					},
				},
			})
			lspconfig.marksman.setup({
				capabilties = capabilities,
			})
			lspconfig.harper_ls.setup({
				settings = {
					linters = {
						userDictPath = "~/harper_ls.txt",
						spell_check = true,
						spelled_numbers = false,
						an_a = true,
						sentence_capitalization = true,
						unclosed_quotes = true,
						wrong_quotes = false,
						long_sentences = true,
						repeated_words = true,
						spaces = true,
						matcher = true,
						correct_number_suffix = true,
						number_suffix_capitalization = true,
						multiple_sequential_pronouns = true,
					},
				},
			})
		end,
	},
}
