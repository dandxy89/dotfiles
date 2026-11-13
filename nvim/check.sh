#!/bin/sh
# Type-check the nvim config: luacheck + stylua + lua-language-server diagnostics.
set -e
cd "$(dirname "$0")"
# lua-language-server needs VIMRUNTIME on its library path; without it, it reports false positives (TSNode, vim.diagnostic.Severity, ...)
VIMRUNTIME="${VIMRUNTIME:-$(nvim --headless -c 'lua io.write(vim.env.VIMRUNTIME)' -c q 2>/dev/null)}"
export VIMRUNTIME
luacheck .
stylua --check .
lua-language-server --check . --checklevel=Hint
nvim --headless --cmd "set rtp^=." -l tests/test_nearest.lua
