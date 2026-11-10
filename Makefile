.PHONY: check test install-nvim link lint-sh

# Symlink shell/git/tmux/fd config into $HOME; existing real files are renamed to *.bak.
LINKS = dots/.zshrc:.zshrc dots/.gitconfig:.gitconfig dots/tmux.conf:.tmux.conf configs/fd/ignore:.config/fd/ignore
link:
	@for l in $(LINKS); do \
		src=$(CURDIR)/$${l%%:*}; dst=$$HOME/$${l##*:}; \
		mkdir -p "$$(dirname "$$dst")"; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then mv "$$dst" "$$dst.bak" && echo "backed up $$dst.bak"; fi; \
		ln -sfn "$$src" "$$dst" && echo "$$dst -> $$src"; \
	done

# Shell lint: needs shellcheck; zsh -n syntax-checks .zshrc.
lint-sh:
	shellcheck scripts/* dots/shell-common.sh nvim/check.sh
	zsh -n dots/.zshrc

# Lint the nvim config (luacheck + lua-language-server) and run its tests.
check:
	./nvim/check.sh

test:
	cd nvim && nvim --headless --cmd "set rtp^=." -l tests/test_nearest.lua

# Symlink nvim config, install plugins and parsers, verify.
install-nvim:
	./scripts/nvim-setup.sh
