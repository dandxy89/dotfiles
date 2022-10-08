--[[ init.lua ]]

-- IMPORTS
require('vars') 
require('opts')
require('keys')
require('plugins')
require('lsp_config')

-- Init Plugins
require('Comment').setup()
