vim.opt_local.wrap = true
vim.opt_local.spell = false

local function format_reload(cmd)
  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = 0,
    callback = function()
      vim.cmd(cmd)
      vim.cmd('edit!')
    end,
  })
end

local tmpfile = vim.fn.shellescape(vim.fn.tempname())
format_reload('!jq . ' .. vim.fn.shellescape(vim.fn.expand('%')) .. ' > ' .. tmpfile .. ' && mv ' .. tmpfile .. ' ' .. vim.fn.shellescape(vim.fn.expand('%')))
