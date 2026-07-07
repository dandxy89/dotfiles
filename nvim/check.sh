#!/bin/sh
# Type-check the nvim config: luacheck + lua-language-server diagnostics.
set -e
cd "$(dirname "$0")"
VIMRUNTIME="${VIMRUNTIME:-$(nvim --headless -c 'lua io.write(vim.env.VIMRUNTIME)' -c q 2>/dev/null)}"
export VIMRUNTIME
luacheck .
lua-language-server --check . --checklevel=Warning
