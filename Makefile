.PHONY: check test install-nvim

# Lint the nvim config (luacheck + lua-language-server) and run its tests.
check:
	./nvim/check.sh

test:
	nvim --headless -l nvim/tests/test_nearest.lua

# Symlink nvim config, install plugins and parsers, verify.
install-nvim:
	./scripts/nvim-setup.sh
