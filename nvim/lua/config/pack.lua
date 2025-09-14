local pack = require("plugins.pack")

for _, plugin in ipairs(pack.plugins) do
    local path = plugin.opt and (vim.fn.stdpath("data") .. "/site/pack/plugins/opt") or
        (vim.fn.stdpath("data") .. "/site/pack/plugins/start")
    local plugin_path = path .. "/" .. plugin.name

    if not vim.loop.fs_stat(plugin_path) then
        print("Installing " .. plugin.name .. "...")
        local cmd = string.format("git clone --depth=1 %s %s", plugin.url, plugin_path)
        vim.fn.system(cmd)

        if plugin.build then
            local current_dir = vim.fn.getcwd()
            vim.fn.chdir(plugin_path)
            vim.fn.system(plugin.build)
            vim.fn.chdir(current_dir)
        end
    end
end

pack.setup_lazy_loading()
require("plugins.config.fzf")
