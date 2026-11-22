#!/usr/bin/env bash
# Bootstrap a macOS machine (Apple Silicon or Intel) for this config.
#
# macOS counterpart of bootstrap-debian.sh. Homebrew covers most of what the
# Debian script builds or downloads by hand, so this one is mostly `brew install`.
#
# What it installs:
#   xcode CLT    compilers for treesitter parsers and cargo
#   brew         git tmux ripgrep bat fd fzf tree-sitter-cli lazygit uv node go
#                lua-language-server marksman checkmake taplo harper shellcheck shfmt
#   cask         ghostty, font-geist-mono, powershell (+ PowerShellEditorServices for nvim)
#   nvim         nightly prebuilt -> ~/Projects/nvim-macos-<arch> (on PATH via dots/.zshrc)
#   zsh          oh-my-zsh + zsh-autosuggestions + zsh-syntax-highlighting (dots/.zshrc needs them)
#   rust         rustup + cargo + rust-analyzer component
#   python       `uv tool install` basedpyright ruff ty autotools-language-server
#   npm          bashls, dockerls, compose, jsonls, yamlls, buf, npm-groovy-lint
#   cargo        lp-lsp + lp_parser_tui
#   dots         `make link` (zshrc, gitconfig, tmux, fd, ghostty, lazygit)
#
# Usage: ./scripts/bootstrap-macos.sh [--skip-config | --upgrade | --help]
#
#   --skip-config  install prerequisites only; do not run ./nvim-setup.sh
#   --upgrade      brew upgrade, re-fetch the nvim nightly, update plugins/parsers
#   (no args)      install prerequisites, link dots, run ./nvim-setup.sh, verify
#
# Safe to re-run: every step is idempotent. Runs under macOS's stock bash 3.2.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}✓${NC} $*"; }
fail() {
  echo -e "  ${RED}✗${NC} $*"
  FAILED=$((FAILED + 1))
}
warn() { echo -e "  ${YELLOW}!${NC} $*"; }
info() { echo -e "  ${BLUE}→${NC} $*"; }
header() { echo -e "\n${BOLD}$*${NC}"; }

FAILED=0
REPO_URL="https://github.com/dandxy89/dotfiles.git"
DEFAULT_CLONE_DIR="${HOME}/Projects/dotfiles"
LOCAL_BIN="${HOME}/.local/bin"
ARCH="$(uname -m)" # arm64 | x86_64 — matches nvim's release asset names
NVIM_DIR="${HOME}/Projects/nvim-macos-${ARCH}"

BREW_FORMULAE=(git tmux ripgrep bat fd fzf tree-sitter-cli lazygit uv node go
  lua-language-server marksman checkmake taplo harper shellcheck shfmt)
BREW_CASKS=(ghostty font-geist-mono powershell)
# nvim/lsp/powershell_es.lua looks for the bundle here.
PSES_DIR="${HOME}/.local/share/powershell_es"

preflight() {
  header "0. Preflight"
  if [[ "$(uname)" != Darwin ]]; then
    fail "not macOS — use bootstrap-debian.sh on Linux"
    exit 1
  fi
  case "${ARCH}" in
    arm64 | x86_64) ;;
    *)
      fail "unsupported architecture '${ARCH}'"
      exit 1
      ;;
  esac
  if [[ "${EUID}" -eq 0 ]]; then
    fail "do not run as root — Homebrew refuses to"
    exit 1
  fi
  # Compilers come from the Command Line Tools; the installer is a GUI prompt, so stop and re-run.
  if ! xcode-select -p &>/dev/null; then
    xcode-select --install || true
    fail "Xcode Command Line Tools missing — finish the installer dialog, then re-run"
    exit 1
  fi
  mkdir -p "${LOCAL_BIN}"
  pass "macOS $(sw_vers -productVersion) (${ARCH}), Command Line Tools present"
}

install_brew() {
  header "1. Homebrew"
  if ! command -v brew &>/dev/null; then
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x "${b}" ]] && eval "$("${b}" shellenv)" && break
    done
  fi
  if command -v brew &>/dev/null; then
    pass "brew present: $(brew --prefix)"
    return
  fi
  info "installing Homebrew (asks for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "${b}" ]] && eval "$("${b}" shellenv)" && break
  done
  command -v brew &>/dev/null || {
    fail "Homebrew install did not produce a brew binary"
    exit 1
  }
  pass "brew installed: $(brew --prefix)"
}

resolve_repo() {
  header "2. Dotfiles repository"
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." 2>/dev/null && pwd)" || script_dir=""

  if [[ -n "${script_dir}" && -f "${script_dir}/nvim/init.lua" ]]; then
    DOTFILES_DIR="${script_dir}"
    pass "running from existing checkout: ${DOTFILES_DIR}"
  elif [[ -f "${DEFAULT_CLONE_DIR}/nvim/init.lua" ]]; then
    DOTFILES_DIR="${DEFAULT_CLONE_DIR}"
    info "found existing checkout, pulling latest: ${DOTFILES_DIR}"
    git -C "${DOTFILES_DIR}" pull --ff-only || warn "git pull failed — continuing with current checkout"
    pass "repository ready: ${DOTFILES_DIR}"
  else
    info "cloning ${REPO_URL} -> ${DEFAULT_CLONE_DIR}"
    mkdir -p "$(dirname "${DEFAULT_CLONE_DIR}")"
    git clone --depth 1 "${REPO_URL}" "${DEFAULT_CLONE_DIR}"
    DOTFILES_DIR="${DEFAULT_CLONE_DIR}"
    pass "cloned to ${DOTFILES_DIR}"
  fi
}

install_brew_packages() {
  header "3. Homebrew packages"
  info "brew install: ${BREW_FORMULAE[*]}"
  if brew install --quiet "${BREW_FORMULAE[@]}"; then
    pass "formulae installed"
  else
    fail "brew install reported errors (shown above)"
  fi
  info "brew install --cask: ${BREW_CASKS[*]}"
  # A cask already installed outside brew (e.g. Ghostty dragged into /Applications) errors; that's fine.
  brew install --quiet --cask "${BREW_CASKS[@]}" || warn "some casks failed — likely already installed manually"
}

install_nvim() {
  header "4. Neovim nightly"
  local tmp url
  tmp="$(mktemp -d)"
  url="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-${ARCH}.tar.gz"
  info "downloading ${url}"
  if ! curl -fL --retry 3 -o "${tmp}/nvim.tar.gz" "${url}"; then
    rm -rf "${tmp}"
    fail "could not download the nvim nightly for ${ARCH}"
    return
  fi
  rm -rf "${NVIM_DIR}"
  mkdir -p "${NVIM_DIR}"
  tar -xzf "${tmp}/nvim.tar.gz" -C "${NVIM_DIR}" --strip-components=1
  rm -rf "${tmp}"
  # Browsers tag downloads with quarantine; curl doesn't, but strip it in case.
  xattr -dr com.apple.quarantine "${NVIM_DIR}" 2>/dev/null || true
  export PATH="${NVIM_DIR}/bin:${PATH}"
  if nvim --version &>/dev/null; then
    pass "nvim installed: $(nvim --version | head -1) -> ${NVIM_DIR}"
  else
    fail "nvim downloaded but does not run"
  fi
}

install_oh_my_zsh() {
  header "5. oh-my-zsh + plugins"
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    pass "oh-my-zsh already present"
  else
    # --keep-zshrc: dots/.zshrc is linked by `make link`, don't let the installer write one.
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    pass "oh-my-zsh installed"
  fi
  local plugins="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins" p
  for p in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -d "${plugins}/${p}" ]]; then
      git -C "${plugins}/${p}" pull --ff-only --quiet || warn "${p}: git pull failed"
    else
      git clone --depth 1 --quiet "https://github.com/zsh-users/${p}" "${plugins}/${p}"
    fi
    pass "${p} ready"
  done
}

install_rust() {
  header "6. Rust (rustup + rust-analyzer)"
  if command -v rustup &>/dev/null; then
    pass "rustup already present: $(rustup --version 2>/dev/null | head -1)"
  else
    info "installing rustup (non-interactive; adds ~/.cargo/bin to ~/.zshenv)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  fi
  # shellcheck disable=SC1090,SC1091
  [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
  export PATH="${HOME}/.cargo/bin:${PATH}"
  rustup component add rust-analyzer
  pass "cargo: $(cargo --version) | rust-analyzer ready"
}

install_language_servers() {
  header "7. Language servers"
  export PATH="${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"

  # Same dir dots/.zshrc puts on PATH via UV_TOOL_BIN_DIR.
  export UV_TOOL_BIN_DIR="${LOCAL_BIN}"
  local t
  for t in basedpyright ruff ty autotools-language-server; do
    uv tool install --quiet "${t}" || fail "uv tool install ${t} failed"
  done
  pass "uv tools: basedpyright ruff ty autotools-language-server"

  # Homebrew's node prefix is user-writable, so -g needs no sudo or prefix override.
  if npm install -g --silent \
    bash-language-server \
    dockerfile-language-server-nodejs \
    @microsoft/compose-language-service \
    vscode-langservers-extracted \
    yaml-language-server \
    @bufbuild/buf \
    npm-groovy-lint; then
    pass "npm language servers installed"
  else
    fail "npm language server install failed"
  fi

  info "cargo install: lp-lsp + lp_parser_tui — this compiles, allow a few minutes"
  cargo install --quiet --locked --git https://github.com/dandxy89/lp_parser_rs lp-lsp lp_parser_tui ||
    fail "cargo install lp-lsp + lp_parser_tui failed"

  install_pses
}

# PowerShell's language server ships as a zip bundle run by pwsh, not as a binary.
install_pses() {
  local tmp
  tmp="$(mktemp -d)"
  if ! curl -fL --retry 3 -o "${tmp}/pses.zip" \
    https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip; then
    rm -rf "${tmp}"
    fail "could not download PowerShellEditorServices"
    return
  fi
  rm -rf "${PSES_DIR}"
  mkdir -p "${PSES_DIR}"
  unzip -q -o "${tmp}/pses.zip" -d "${PSES_DIR}"
  rm -rf "${tmp}"
  pass "PowerShellEditorServices -> ${PSES_DIR}"
}

link_dots() {
  header "8. Dotfiles (make link)"
  if make -C "${DOTFILES_DIR}" link; then
    pass "dots linked (existing real files renamed to *.bak)"
  else
    fail "make link failed"
  fi
  warn "open a new shell (or 'exec zsh') for changes to take effect"
}

run_nvim_setup() {
  header "9. Neovim config (symlink + plugins + parsers + verify)"
  export PATH="${NVIM_DIR}/bin:${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"
  if "${DOTFILES_DIR}/scripts/nvim-setup.sh"; then
    pass "nvim-setup.sh completed"
  else
    fail "nvim-setup.sh reported errors (shown above)"
  fi
}

verify_tools() {
  header "10. Installed binaries"
  export PATH="${NVIM_DIR}/bin:${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"
  local bin
  for bin in nvim fzf tree-sitter lazygit rg tmux bat fd cargo rust-analyzer uv npm \
    marksman lua-language-server taplo harper-ls basedpyright-langserver ruff ty lp-lsp shellcheck shfmt pwsh; do
    if command -v "${bin}" &>/dev/null; then
      pass "${bin}: $(command -v "${bin}")"
    else
      fail "${bin} not found on PATH"
    fi
  done
}

finish() {
  echo ""
  if [[ "${FAILED}" -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}$1 — all checks passed.${NC}"
  else
    echo -e "${RED}${BOLD}${FAILED} check(s) failed.${NC}"
    exit 1
  fi
}

SKIP_CONFIG=0
case "${1:-}" in
  --help | -h)
    sed -n '2,/^$/s/^# \{0,1\}//p' "$0"
    exit 0
    ;;
  --skip-config) SKIP_CONFIG=1 ;;
  --upgrade)
    echo -e "${BOLD}macOS upgrade — brew + nvim nightly + plugins${NC}"
    preflight
    install_brew
    resolve_repo
    brew upgrade --quiet || fail "brew upgrade reported errors"
    install_nvim
    "${DOTFILES_DIR}/scripts/nvim-setup.sh" --upgrade || fail "nvim-setup.sh --upgrade failed"
    finish "Upgrade complete"
    exit 0
    ;;
  "") ;;
  *)
    echo "Unknown option: $1 (try --help)" >&2
    exit 1
    ;;
esac

echo -e "${BOLD}Bootstrap — macOS (Python + Rust)${NC}"
preflight
install_brew
resolve_repo
install_brew_packages
install_nvim
install_oh_my_zsh
install_rust
install_language_servers
link_dots

if [[ "${SKIP_CONFIG}" -eq 0 ]]; then
  run_nvim_setup
  verify_tools
else
  info "--skip-config set: run '${DOTFILES_DIR}/scripts/nvim-setup.sh' yourself when ready"
fi

finish "Bootstrap complete"
