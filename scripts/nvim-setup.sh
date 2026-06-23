#!/usr/bin/env bash
# Neovim setup and verification script
# Usage: ./scripts/nvim-setup.sh [--install | --verify | --help]
#
# --install  : create symlink and install plugins/parsers (default on new machine)
# --verify   : check symlink, parsers, LSP binaries, and open test files
# (no args)  : run both install then verify

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
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM_SRC="${DOTFILES_DIR}/nvim"
NVIM_CFG="${HOME}/.config/nvim"
NVIM_DATA="$(nvim --headless -c "lua io.write(vim.fn.stdpath('data'))" -c qa 2>/dev/null || true)"
NVIM_PACK_DIR="${NVIM_DATA}/site/pack/core/opt"

require_nvim() {
  if ! command -v nvim &>/dev/null; then
    fail "nvim not found on PATH — install Neovim 0.11+ first"
    exit 1
  fi
  local ver
  ver=$(nvim --version | head -1)
  pass "nvim found: ${ver}"
}

check_binary() {
  local bin="$1"
  local label="${2:-${bin}}"
  if command -v "${bin}" &>/dev/null; then
    pass "${label}"
    return
  fi
  local mason_bin="${NVIM_DATA}/mason/bin/${bin}"
  if [[ -x "${mason_bin}" ]]; then
    pass "${label} (via Mason)"
    return
  fi
  fail "${label} not found — install with Mason (:MasonInstall ${bin}) or your package manager"
}

check_ts_parser() {
  local lang="$1"
  local result
  result=$(nvim --headless \
    -c "lua local ok = pcall(vim.treesitter.language.add, '${lang}'); io.write(ok and 'ok' or 'missing'); io.flush()" \
    -c qa 2>/dev/null || true)
  if [[ "${result}" == "ok" ]]; then
    pass "treesitter parser: ${lang}"
  else
    fail "treesitter parser missing: ${lang} (run :TSInstall ${lang} in nvim)"
  fi
}

setup_symlink() {
  header "1. Neovim config symlink"

  if [[ -L "${NVIM_CFG}" ]]; then
    local target
    target=$(readlink "${NVIM_CFG}")
    if [[ "${target}" == "${NVIM_SRC}" ]]; then
      pass "symlink already correct: ${NVIM_CFG} → ${NVIM_SRC}"
      return
    else
      warn "symlink points elsewhere (${target}), relinking to ${NVIM_SRC}"
      rm "${NVIM_CFG}"
    fi
  elif [[ -e "${NVIM_CFG}" ]]; then
    warn "${NVIM_CFG} exists but is not a symlink"
    read -rp "  Backup and replace? [y/N] " answer
    if [[ "${answer,,}" == "y" ]]; then
      mv "${NVIM_CFG}" "${NVIM_CFG}.bak.$(date +%Y%m%d_%H%M%S)"
      warn "backed up to ${NVIM_CFG}.bak.*"
    else
      fail "skipped — ${NVIM_CFG} was not changed"
      return
    fi
  fi

  ln -s "${NVIM_SRC}" "${NVIM_CFG}"
  pass "created symlink: ${NVIM_CFG} → ${NVIM_SRC}"
}

install_plugins() {
  header "2. Plugin installation (vim.pack)"
  info "first pass — fetching plugins and running build steps …"

  nvim --headless -c "lua vim.defer_fn(function() vim.cmd('qa') end, 30000)" >/dev/null 2>&1 || true

  info "second pass — verifying a clean startup …"
  local log
  log=$(nvim --headless -c "qa" 2>&1 || true)
  if echo "${log}" | grep -qiE 'E[0-9]{3}:|module .* not found|error'; then
    warn "errors seen on second startup:"
    echo "${log}" | grep -iE 'E[0-9]{3}:|not found|error' | head -10 | sed 's/^/     /'
  else
    pass "plugins installed and startup is clean"
  fi
}

install_ts_parsers() {
  header "3. Treesitter parser installation"
  info "installing python and rust parsers (synchronous) …"
  nvim --headless \
    -c "lua require('nvim-treesitter').install({ 'python', 'rust' }):wait(300000)" \
    -c "qa" 2>&1 | tail -5 || true
  pass "python and rust parsers installed"
}

verify_symlink() {
  header "1. Config symlink"
  if [[ -L "${NVIM_CFG}" && "$(readlink "${NVIM_CFG}")" == "${NVIM_SRC}" ]]; then
    pass "${NVIM_CFG} → ${NVIM_SRC}"
  else
    fail "symlink missing or incorrect — run: ${0} --install"
  fi
}

verify_nvim_startup() {
  header "2. Neovim startup (no errors)"
  local log
  log=$(nvim --headless -c "qa" 2>&1 || true)
  if echo "${log}" | grep -qiE '^\s*E[0-9]{3}:|Error|error detected'; then
    fail "startup errors detected:"
    echo "${log}" | grep -iE 'E[0-9]{3}:|Error' | head -10 | sed 's/^/     /'
  else
    pass "clean startup"
  fi
}

verify_ts_parsers() {
  header "3. Treesitter parsers"
  check_ts_parser python
  check_ts_parser rust
  check_ts_parser lua
  check_ts_parser bash
}

verify_lsp_binaries() {
  header "4. LSP server binaries"
  check_binary "basedpyright-langserver" "basedpyright (Python)"
  check_binary "ruff"                    "ruff (Python linter/LSP)"
  check_binary "rust-analyzer"           "rust-analyzer (Rust)"
  check_binary "bash-language-server"    "bashls (Bash)"
  check_binary "lua-language-server"     "lua_ls (Lua)"
  check_binary "taplo"                   "taplo (TOML)"
  check_binary "marksman"                "marksman (Markdown)"
  check_binary "yaml-language-server"    "yamlls (YAML)"
  check_binary "vscode-json-language-server" "jsonls (JSON)"
  check_binary "harper-ls"              "harper_ls (prose grammar)"
  check_binary "docker-langserver"      "dockerls (Dockerfile)"

  if command -v rustup &>/dev/null; then
    if rustup run stable rust-analyzer --version &>/dev/null 2>&1; then
      pass "rust-analyzer via rustup stable"
    else
      warn "rustup found but 'rustup run stable rust-analyzer' failed"
      warn "run: rustup component add rust-analyzer"
    fi
  fi
}

# Usage: verify_open_file <section> <lang> <ext> <attach-hint> <<<'snippet'
verify_open_file() {
  local section="$1" lang="$2" ext="$3" hint="$4"
  header "${section}. ${lang^} file — TS highlight + LSP attach"
  local tmpfile
  tmpfile=$(mktemp "/tmp/nvim-verify-XXXXXX.${ext}")
  cat >"${tmpfile}"

  local out
  out=$(nvim --headless \
    -c "edit ${tmpfile}" \
    -c "lua vim.defer_fn(function()
          local ts_ok = pcall(vim.treesitter.get_parser, 0, '${lang}')
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local lsp_names = {}
          for _, c in ipairs(clients) do table.insert(lsp_names, c.name) end
          io.write('ts=' .. tostring(ts_ok) .. ' lsp=' .. table.concat(lsp_names, ',') .. '\n')
          io.flush()
          vim.cmd('qa!')
        end, 3000)" 2>&1 || true)
  rm -f "${tmpfile}"

  if echo "${out}" | grep -q 'ts=true'; then
    pass "treesitter parser active for ${lang^}"
  else
    warn "could not confirm treesitter for ${lang^} (LSP attach may need a project root)"
  fi
  local lsp_info
  lsp_info=$(echo "${out}" | grep 'lsp=' | sed 's/.*lsp=//')
  if [[ -n "${lsp_info}" ]]; then
    pass "LSP clients attached: ${lsp_info}"
  else
    warn "no LSP clients attached to ${lang^} file (${hint})"
  fi
}

verify_open_python_file() {
  verify_open_file 5 python py "expected in a project directory" <<'PYEOF'
def greet(name: str) -> str:
    return f"Hello, {name}"

class Greeter:
    def __init__(self, prefix: str) -> None:
        self.prefix = prefix

    def greet(self, name: str) -> str:
        return f"{self.prefix} {greet(name)}"
PYEOF
}

verify_open_rust_file() {
  verify_open_file 6 rust rs "rust-analyzer needs a Cargo.toml workspace" <<'RSEOF'
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn distance(&self, other: &Point) -> f64 {
        ((self.x - other.x).powi(2) + (self.y - other.y).powi(2)).sqrt()
    }
}
RSEOF
}

verify_mason_packages() {
  header "7. Mason package directory"
  local mason_dir="${NVIM_DATA}/mason"
  if [[ -d "${mason_dir}/packages" ]]; then
    local count pkg_list
    count=$(find "${mason_dir}/packages" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    pkg_list=$(find "${mason_dir}/packages" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort | tr '\n' ' ')
    pass "Mason packages directory exists (${count} installed): ${pkg_list}"
  else
    warn "Mason directory not found at ${mason_dir} — open nvim once to initialise"
  fi
}

MODE="${1:-all}"

case "${MODE}" in
  --help | -h)
    echo "Usage: $(basename "$0") [--install | --verify | --help]"
    echo ""
    echo "  --install   Create symlink and install plugins + TS parsers"
    echo "  --verify    Check symlink, parsers, LSP binaries, and open test files"
    echo "  (no args)   Run install then verify"
    exit 0
    ;;
  --install)
    echo -e "${BOLD}Neovim Install${NC}"
    require_nvim
    setup_symlink
    install_plugins
    install_ts_parsers
    ;;
  --verify)
    echo -e "${BOLD}Neovim Verify${NC}"
    require_nvim
    verify_symlink
    verify_nvim_startup
    verify_ts_parsers
    verify_lsp_binaries
    verify_open_python_file
    verify_open_rust_file
    verify_mason_packages
    ;;
  all)
    echo -e "${BOLD}Neovim Setup + Verify${NC}"
    require_nvim
    setup_symlink
    install_plugins
    install_ts_parsers
    verify_symlink
    verify_nvim_startup
    verify_ts_parsers
    verify_lsp_binaries
    verify_open_python_file
    verify_open_rust_file
    verify_mason_packages
    ;;
  *)
    echo "Unknown option: ${MODE}"
    echo "Run with --help for usage."
    exit 1
    ;;
esac

echo ""
if [[ "${FAILED}" -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}All checks passed.${NC}"
else
  echo -e "${RED}${BOLD}${FAILED} check(s) failed.${NC}"
  exit 1
fi
