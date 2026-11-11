-- :checkhealth core
local M = {}

function M.check()
  vim.health.start('blink.cmp fuzzy library')

  local ok, err = pcall(vim.cmd.packadd, 'blink-cmp')
  if not ok then
    vim.health.error('blink-cmp is not installed', tostring(err))
    return
  end

  if pcall(require, 'blink.cmp.fuzzy.rust') then
    vim.health.ok('Rust fuzzy library loads')
    return
  end

  vim.health.warn('Rust fuzzy library missing; blink is using the Lua fallback', {
    'Restart Neovim to retry the prebuilt download',
    'Or build it: cd ' .. vim.fn.stdpath('data') .. '/site/pack/core/opt/blink-cmp && cargo build --release',
  })
  vim.health.info(vim.fn.executable('cargo') == 1 and 'cargo found' or 'cargo not found on PATH')
end

return M
