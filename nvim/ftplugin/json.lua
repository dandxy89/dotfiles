vim.opt_local.wrap = true
vim.opt_local.spell = false

require('util.format').format_reload('!jq . % > /tmp/jq_temp && mv /tmp/jq_temp %')
