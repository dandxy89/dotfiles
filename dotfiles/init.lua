-- [[ init.lua ]] 
require('vars')
require('opts')
require('keys')
require('plugins')
require('lsp_config')

-- Init Plugins
require('leap').add_default_mappings()
