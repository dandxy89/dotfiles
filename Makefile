.PHONY: check test install-nvim link lint-sh fmt-sh upgrade

# Symlink shell/git/tmux/fd/ghostty config into $HOME; existing real files are renamed to *.bak.
LINKS = dots/.zshrc:.zshrc dots/.gitconfig:.gitconfig dots/tmux.conf:.tmux.conf configs/fd/ignore:.config/fd/ignore \
	dots/ghostty/themes:.config/ghostty/themes
link:
	@for l in $(LINKS); do \
		src=$(CURDIR)/$${l%%:*}; dst=$$HOME/$${l##*:}; \
		mkdir -p "$$(dirname "$$dst")"; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then mv "$$dst" "$$dst.bak" && echo "backed up $$dst.bak"; fi; \
		ln -sfn "$$src" "$$dst" && echo "$$dst -> $$src"; \
	done
	@# lazygit's config dir is OS-specific (macOS: ~/Library/Application Support/lazygit).
	@if command -v lazygit >/dev/null; then \
		dst="$$(lazygit --print-config-dir)/config.yml"; mkdir -p "$$(dirname "$$dst")"; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then mv "$$dst" "$$dst.bak" && echo "backed up $$dst.bak"; fi; \
		ln -sfn "$(CURDIR)/dots/lazygit.yml" "$$dst" && echo "$$dst -> $(CURDIR)/dots/lazygit.yml"; \
	fi
	@# Ghostty on macOS reads Application Support last, so link the config there.
	@if [ "$$(uname)" = Darwin ]; then \
		dst="$$HOME/Library/Application Support/com.mitchellh.ghostty/config"; mkdir -p "$$(dirname "$$dst")"; \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then mv "$$dst" "$$dst.bak" && echo "backed up $$dst.bak"; fi; \
		ln -sfn "$(CURDIR)/dots/ghostty/config" "$$dst" && echo "$$dst -> $(CURDIR)/dots/ghostty/config"; \
	fi

# Shell lint: shellcheck + shfmt (same tools bashls uses); zsh -n syntax-checks .zshrc (shellcheck has no zsh mode).
# PowerShell: PSScriptAnalyzer via pwsh, skipped when pwsh is absent (CI always runs it).
SH_FILES = $(filter-out %.ps1,$(wildcard scripts/*)) dots/shell-common.sh nvim/check.sh
PS_FILES = $(wildcard scripts/*.ps1)
SHFMT = shfmt -i 2 -ci
lint-sh:
	shellcheck $(SH_FILES)
	$(SHFMT) -d $(SH_FILES)
	zsh -n dots/.zshrc
	@if command -v pwsh >/dev/null; then \
		for f in $(PS_FILES); do \
			pwsh -NoProfile -Command "if (Invoke-ScriptAnalyzer -Path '$$f' -Severity Warning,Error) { Invoke-ScriptAnalyzer -Path '$$f' -Severity Warning,Error | Format-Table -AutoSize | Out-String | Write-Output; exit 1 }" || exit 1; \
		done; echo "PSScriptAnalyzer: clean"; \
	else echo "pwsh not found: skipping PSScriptAnalyzer"; fi

fmt-sh:
	$(SHFMT) -w $(SH_FILES)

# Lint the nvim config (luacheck + lua-language-server) and run its tests.
check:
	./nvim/check.sh

test:
	cd nvim && nvim --headless --cmd "set rtp^=." -l tests/test_nearest.lua

# Symlink nvim config, install plugins and parsers, verify.
install-nvim:
	./scripts/nvim-setup.sh

# Update nvim plugins and verify startup.
upgrade:
	./scripts/nvim-setup.sh --upgrade
