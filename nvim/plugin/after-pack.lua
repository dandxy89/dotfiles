-- This file loads AFTER pack plugins are loaded because it's in the plugin/ directory

require("plugins.config.theme")
require("plugins.config.snacks")
require("plugins.config.statusline")
pcall(require, "plugins.config.copilot")
