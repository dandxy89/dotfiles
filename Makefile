LP_DIR ?= $(HOME)/Projects/tree-sitter-lp
NVIM_DIR ?= $(HOME)/.config/nvim

# Regenerate the tree-sitter-lp parser in LP_DIR, vendor it and the queries
# into NVIM_DIR, then force-reinstall it with nvim-treesitter (main branch API).
nvim-sync:
	cd $(LP_DIR) && tree-sitter generate
	mkdir -p $(NVIM_DIR)/tree-sitter-lp/src/tree_sitter $(NVIM_DIR)/queries/lp
	cp $(LP_DIR)/src/*.c $(LP_DIR)/src/grammar.json $(NVIM_DIR)/tree-sitter-lp/src/
	cp $(LP_DIR)/src/tree_sitter/*.h $(NVIM_DIR)/tree-sitter-lp/src/tree_sitter/
	cp $(LP_DIR)/queries/*.scm $(NVIM_DIR)/queries/lp/
	nvim --headless -c 'lua require("nvim-treesitter").install({ "lp" }, { force = true }):wait(300000)' -c q

.PHONY: nvim-sync
