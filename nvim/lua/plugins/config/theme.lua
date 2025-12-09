-- vim.cmd.colorscheme('anysphere')
-- local ok = pcall(vim.cmd.colorscheme, 'vhs-era-theme')
-- if not ok then
--   vim.notify('vhs-era theme not installed. Run :PackInstall', vim.log.levels.WARN)
-- end
local ok = pcall(vim.cmd.colorscheme, 'koda')
if not ok then
  vim.notify('koda theme not installed. Run :PackInstall', vim.log.levels.WARN)
end
