#!/usr/bin/env bash
# Bootstrap a Debian/Ubuntu machine for this Neovim config (Python + Rust focus).
#
# Installs every system prerequisite the config needs, then hands off to
# ./nvim-setup.sh for the config symlink, plugins, and treesitter parsers.
#
# What it installs:
#   apt          build-essential git curl unzip tmux ripgrep bat fd-find
#   fzf          latest prebuilt binary (apt's is too old for fzf-lua)
#   nvim         latest stable prebuilt -> /opt/nvim (builds from source if glibc too old)
#   tree-sitter  latest CLI binary -> /usr/local/bin (generates extra parsers)
#   lazygit      latest binary -> /usr/local/bin (used by nvim's snacks.lazygit)
#   rust         rustup + cargo + rust-analyzer component
#   python       uv, then `uv tool install` basedpyright + ruff
#
# Note: python & rust treesitter parsers compile via the C compiler (build-essential);
# the tree-sitter CLI installed here covers parsers that need a generator (bash, markdown, …).
#
# Usage: ./scripts/bootstrap-debian.sh [--skip-config | --help]
#
#   --skip-config  install prerequisites only; do not run ./nvim-setup.sh
#   (no args)      install prerequisites, then run ./nvim-setup.sh --install,
#                  then verify the Python + Rust toolchain
#
# Safe to re-run: every step is idempotent.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}✓${NC} $*"; }
fail() { echo -e "  ${RED}✗${NC} $*"; FAILED=$((FAILED + 1)); }
warn() { echo -e "  ${YELLOW}!${NC} $*"; }
info() { echo -e "  ${BLUE}→${NC} $*"; }
header() { echo -e "\n${BOLD}$*${NC}"; }

FAILED=0
NVIM_OK=0
REPO_URL="https://github.com/dandxy89/dotfiles.git"
DEFAULT_CLONE_DIR="${HOME}/Projects/dotfiles"
LOCAL_BIN="${HOME}/.local/bin"

detect_sudo() {
  if [[ "${EUID}" -eq 0 ]]; then
    SUDO=""
  elif command -v sudo &>/dev/null; then
    SUDO="sudo"
  else
    echo "error: not root and 'sudo' is unavailable — cannot install packages" >&2
    exit 1
  fi
}

detect_arch() {
  case "$(uname -m)" in
    x86_64 | amd64) NVIM_ARCH="x86_64" ;;
    aarch64 | arm64) NVIM_ARCH="arm64" ;;
    *)
      echo "error: unsupported architecture '$(uname -m)'" >&2
      exit 1
      ;;
  esac
}

preflight() {
  header "0. Preflight"
  if ! command -v apt-get &>/dev/null; then
    fail "apt-get not found — this script targets Debian/Ubuntu only"
    exit 1
  fi
  detect_sudo
  detect_arch
  mkdir -p "${LOCAL_BIN}"
  pass "Debian/Ubuntu detected (arch: ${NVIM_ARCH})"
  if [[ -n "${SUDO}" ]]; then
    info "using sudo for privileged steps"
  else
    info "running as root"
  fi
}

resolve_repo() {
  header "1. Dotfiles repository"
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  if [[ -f "${script_dir}/nvim/init.lua" ]]; then
    DOTFILES_DIR="${script_dir}"
    pass "running from existing checkout: ${DOTFILES_DIR}"
    return
  fi

  if [[ -f "${DEFAULT_CLONE_DIR}/nvim/init.lua" ]]; then
    DOTFILES_DIR="${DEFAULT_CLONE_DIR}"
    info "found existing checkout, pulling latest: ${DOTFILES_DIR}"
    git -C "${DOTFILES_DIR}" pull --ff-only || warn "git pull failed — continuing with current checkout"
    pass "repository ready: ${DOTFILES_DIR}"
    return
  fi

  if ! command -v git &>/dev/null || ! command -v curl &>/dev/null; then
    info "installing git/curl to fetch the repository …"
    ${SUDO} apt-get update -qq
    DEBIAN_FRONTEND=noninteractive ${SUDO} apt-get install -y -qq git curl ca-certificates
  fi

  info "cloning ${REPO_URL} -> ${DEFAULT_CLONE_DIR}"
  mkdir -p "$(dirname "${DEFAULT_CLONE_DIR}")"
  git clone --depth 1 "${REPO_URL}" "${DEFAULT_CLONE_DIR}"
  DOTFILES_DIR="${DEFAULT_CLONE_DIR}"
  pass "cloned to ${DOTFILES_DIR}"
}

install_apt_packages() {
  header "2. System packages (apt)"
  local pkgs=(build-essential git curl unzip ca-certificates tmux ripgrep bat fd-find)
  info "apt-get update …"
  ${SUDO} apt-get update -qq
  info "installing: ${pkgs[*]}"
  DEBIAN_FRONTEND=noninteractive ${SUDO} apt-get install -y -qq "${pkgs[@]}"
  pass "apt packages installed"

  # Debian renames these binaries; the nvim config calls `bat` and `fd` directly.
  if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
    ln -sf "$(command -v batcat)" "${LOCAL_BIN}/bat"
    pass "symlinked batcat -> ${LOCAL_BIN}/bat"
  fi
  if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    ln -sf "$(command -v fdfind)" "${LOCAL_BIN}/fd"
    pass "symlinked fdfind -> ${LOCAL_BIN}/fd"
  fi
}

install_fzf() {
  header "3. fzf (prebuilt)"
  # apt's fzf is frequently below fzf-lua's 0.36 floor, so fetch fzf's own binary.
  local fzf_dir="${HOME}/.fzf"
  if [[ -d "${fzf_dir}/.git" ]]; then
    info "updating existing fzf checkout"
    git -C "${fzf_dir}" pull --ff-only || warn "fzf git pull failed — reusing current binary"
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git "${fzf_dir}"
  fi
  # --bin downloads the prebuilt binary only; it does not touch any shell rc files.
  "${fzf_dir}/install" --bin
  ln -sf "${fzf_dir}/bin/fzf" "${LOCAL_BIN}/fzf"
  pass "fzf installed: $("${LOCAL_BIN}/fzf" --version 2>/dev/null || echo '?')"
}

install_nvim() {
  header "4. Neovim (prebuilt, source fallback)"
  local tmp url
  tmp="$(mktemp -d)"
  trap 'rm -rf "${tmp}"' RETURN

  url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
  info "downloading ${url}"
  if ! curl -fL --retry 3 -o "${tmp}/nvim.tar.gz" "${url}"; then
    if [[ "${NVIM_ARCH}" == "x86_64" ]]; then
      warn "new asset name failed, trying legacy nvim-linux64.tar.gz"
      curl -fL --retry 3 -o "${tmp}/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    else
      warn "could not download a prebuilt Neovim for ${NVIM_ARCH}"
      build_nvim_from_source
      return
    fi
  fi

  ${SUDO} rm -rf /opt/nvim
  ${SUDO} mkdir -p /opt/nvim
  ${SUDO} tar -xzf "${tmp}/nvim.tar.gz" -C /opt/nvim --strip-components=1
  ${SUDO} ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

  if /usr/local/bin/nvim --version &>/dev/null; then
    NVIM_OK=1
    pass "nvim installed: $(/usr/local/bin/nvim --version | head -1)"
  else
    warn "prebuilt nvim will not run here (glibc too old):"
    /usr/local/bin/nvim --version 2>&1 | head -1 | sed 's/^/     /' || true
    build_nvim_from_source
  fi
}

build_nvim_from_source() {
  info "falling back to building Neovim from source (several minutes) …"
  info "installing build deps: ninja-build gettext cmake"
  if ! DEBIAN_FRONTEND=noninteractive ${SUDO} apt-get install -y -qq ninja-build gettext cmake; then
    fail "could not install Neovim build dependencies"
    return
  fi
  local bld
  bld="$(mktemp -d)"
  info "cloning neovim (stable branch, shallow) …"
  if ! git clone --depth 1 --branch stable https://github.com/neovim/neovim "${bld}/neovim"; then
    fail "git clone of neovim failed"
    rm -rf "${bld}"
    return
  fi
  info "compiling (CMAKE_BUILD_TYPE=Release, prefix=/opt/nvim) …"
  if make -C "${bld}/neovim" CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/nvim >/dev/null; then
    ${SUDO} rm -rf /opt/nvim
    ${SUDO} make -C "${bld}/neovim" install >/dev/null
    ${SUDO} ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  else
    fail "Neovim source build failed"
    rm -rf "${bld}"
    return
  fi
  rm -rf "${bld}"

  if /usr/local/bin/nvim --version &>/dev/null; then
    NVIM_OK=1
    pass "nvim built from source: $(/usr/local/bin/nvim --version | head -1)"
  else
    fail "source build completed but nvim still fails to run:"
    /usr/local/bin/nvim --version 2>&1 | head -3 | sed 's/^/     /' || true
  fi
}

install_tree_sitter() {
  header "5. tree-sitter CLI"
  local ts_arch tmp url
  case "${NVIM_ARCH}" in
    x86_64) ts_arch="x64" ;;
    arm64) ts_arch="arm64" ;;
  esac
  tmp="$(mktemp -d)"
  trap 'rm -rf "${tmp}"' RETURN

  url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${ts_arch}.gz"
  info "downloading ${url}"
  if ! curl -fL --retry 3 -o "${tmp}/tree-sitter.gz" "${url}"; then
    fail "could not download tree-sitter CLI for ${NVIM_ARCH}"
    return
  fi
  gunzip -f "${tmp}/tree-sitter.gz"
  ${SUDO} install -m 0755 "${tmp}/tree-sitter" /usr/local/bin/tree-sitter
  pass "tree-sitter installed: $(/usr/local/bin/tree-sitter --version 2>/dev/null || echo '?')"
}

install_lazygit() {
  header "6. lazygit"
  # nvim's snacks.nvim integration shells out to the lazygit binary.
  local tmp ver url
  tmp="$(mktemp -d)"
  trap 'rm -rf "${tmp}"' RETURN

  info "resolving latest lazygit release"
  ver="$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep -Po '"tag_name":\s*"v\K[^"]*' || true)"
  if [[ -z "${ver}" ]]; then
    fail "could not resolve latest lazygit version (GitHub API rate limit?)"
    return
  fi

  url="https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_${NVIM_ARCH}.tar.gz"
  info "downloading ${url}"
  if ! curl -fL --retry 3 -o "${tmp}/lazygit.tar.gz" "${url}"; then
    fail "could not download lazygit ${ver} for ${NVIM_ARCH}"
    return
  fi
  tar -xzf "${tmp}/lazygit.tar.gz" -C "${tmp}" lazygit
  ${SUDO} install -m 0755 "${tmp}/lazygit" /usr/local/bin/lazygit
  pass "lazygit installed: $(/usr/local/bin/lazygit --version 2>/dev/null | head -1 || echo '?')"
}

install_rust() {
  header "7. Rust (rustup + rust-analyzer)"
  if command -v rustup &>/dev/null; then
    pass "rustup already present: $(rustup --version | head -1)"
  else
    info "installing rustup (non-interactive)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
      sh -s -- -y --no-modify-path --default-toolchain stable
  fi
  # shellcheck disable=SC1090,SC1091
  [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
  export PATH="${HOME}/.cargo/bin:${PATH}"
  info "adding rust-analyzer component"
  rustup component add rust-analyzer
  pass "cargo: $(cargo --version) | rust-analyzer ready"
}

install_python_tools() {
  header "8. Python LSP tools (uv)"
  if command -v uv &>/dev/null; then
    pass "uv already present: $(uv --version)"
  else
    info "installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
  export PATH="${LOCAL_BIN}:${PATH}"
  info "uv tool install basedpyright ruff"
  uv tool install --quiet basedpyright
  uv tool install --quiet ruff
  pass "basedpyright + ruff installed via uv"
}

ensure_path() {
  header "9. PATH configuration"
  local marker="# >>> dotfiles bootstrap >>>"
  local block
  block="${marker}
export PATH=\"\$HOME/.local/bin:\$HOME/.cargo/bin:\$PATH\"
# <<< dotfiles bootstrap <<<"

  local rc
  for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
    if [[ -f "${rc}" ]] && grep -qF "${marker}" "${rc}"; then
      pass "PATH block already present in $(basename "${rc}")"
    else
      printf '\n%s\n' "${block}" >>"${rc}"
      pass "added PATH block to $(basename "${rc}")"
    fi
  done
  warn "open a new shell (or 'source ~/.zshrc') for PATH changes to take effect"
}

run_nvim_setup() {
  header "10. Neovim config (symlink + plugins + parsers)"
  export PATH="${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"
  if [[ "${NVIM_OK}" -ne 1 ]]; then
    fail "skipping config — nvim is not runnable on this OS (see step 4)"
    return
  fi
  if [[ ! -x "${DOTFILES_DIR}/scripts/nvim-setup.sh" ]]; then
    fail "scripts/nvim-setup.sh not found or not executable in ${DOTFILES_DIR}"
    return
  fi

  if "${DOTFILES_DIR}/scripts/nvim-setup.sh" --install; then
    pass "nvim-setup.sh --install completed"
  else
    fail "nvim-setup.sh --install reported errors (shown above)"
  fi
}

check_binary() {
  local bin="$1" label="${2:-$1}"
  if command -v "${bin}" &>/dev/null; then
    pass "${label}: $(command -v "${bin}")"
  else
    fail "${label} not found on PATH"
  fi
}

check_ts_parser() {
  local lang="$1" result
  result=$(nvim --headless \
    -c "lua local ok = pcall(vim.treesitter.language.add, '${lang}'); io.write(ok and 'ok' or 'missing'); io.flush()" \
    -c qa 2>/dev/null || true)
  if [[ "${result}" == "ok" ]]; then
    pass "treesitter parser: ${lang}"
  else
    fail "treesitter parser missing: ${lang}"
  fi
}

verify_all() {
  header "11. Verification (Python + Rust)"
  export PATH="${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"

  check_binary nvim "nvim"
  check_binary fzf "fzf"
  check_binary tree-sitter "tree-sitter (CLI)"
  check_binary lazygit "lazygit"
  check_binary rg "ripgrep"
  check_binary tmux "tmux"
  check_binary bat "bat"
  check_binary fd "fd"
  check_binary cargo "cargo (Rust)"
  check_binary rust-analyzer "rust-analyzer (Rust LSP)"
  check_binary basedpyright-langserver "basedpyright (Python LSP)"
  check_binary ruff "ruff (Python LSP/linter)"
  check_binary uv "uv"

  if command -v nvim &>/dev/null && /usr/local/bin/nvim --version &>/dev/null; then
    check_ts_parser python
    check_ts_parser rust
  else
    warn "skipping treesitter checks — nvim is not runnable"
  fi
}

SKIP_CONFIG=0
case "${1:-}" in
  --help | -h)
    sed -n '2,23p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
  --skip-config) SKIP_CONFIG=1 ;;
  "") ;;
  *)
    echo "Unknown option: $1 (try --help)" >&2
    exit 1
    ;;
esac

echo -e "${BOLD}Neovim Bootstrap — Debian/Ubuntu (Python + Rust)${NC}"
preflight
resolve_repo
install_apt_packages
install_fzf
install_nvim
install_tree_sitter
install_lazygit
install_rust
install_python_tools
ensure_path

if [[ "${SKIP_CONFIG}" -eq 0 ]]; then
  run_nvim_setup
  verify_all
else
  info "--skip-config set: run '${DOTFILES_DIR}/scripts/nvim-setup.sh' yourself when ready"
fi

echo ""
if [[ "${FAILED}" -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}Bootstrap complete — all checks passed.${NC}"
else
  echo -e "${RED}${BOLD}${FAILED} check(s) failed.${NC}"
  exit 1
fi
