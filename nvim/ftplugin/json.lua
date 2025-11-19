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

format_reload('!jq . % > /tmp/jq_temp && mv /tmp/jq_temp %')
