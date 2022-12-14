-- Automatically generated packer.nvim plugin loader code
if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
    vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
    return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

    _G._packer = _G._packer or {}
    _G._packer.inside_compile = true

    local time
    local profile_info
    local should_profile = false
    if should_profile then
        local hrtime = vim.loop.hrtime
        profile_info = {}
        time = function(chunk, start)
            if start then
                profile_info[chunk] = hrtime()
            else
                profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
            end
        end
    else
        time = function(chunk, start)
        end
    end

    local function save_profiles(threshold)
        local sorted_times = {}
        for chunk_name, time_taken in pairs(profile_info) do
            sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
        end
        table.sort(sorted_times, function(a, b)
            return a[2] > b[2]
        end)
        local results = {}
        for i, elem in ipairs(sorted_times) do
            if not threshold or threshold and elem[2] > threshold then
                results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
            end
        end
        if threshold then
            table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
        end

        _G._packer.profile_output = results
    end

    time([[Luarocks path setup]], true)
    local package_path_str =
        "/Users/i98012/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/i98012/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/i98012/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/i98012/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
    local install_cpath_pattern = "/Users/i98012/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
    if not string.find(package.path, package_path_str, 1, true) then
        package.path = package.path .. ';' .. package_path_str
    end

    if not string.find(package.cpath, install_cpath_pattern, 1, true) then
        package.cpath = package.cpath .. ';' .. install_cpath_pattern
    end

    time([[Luarocks path setup]], false)
    time([[try_loadstring definition]], true)
    local function try_loadstring(s, component, name)
        local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
        if not success then
            vim.schedule(function()
                vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result,
                    vim.log.levels.ERROR, {})
            end)
        end
        return result
    end

    time([[try_loadstring definition]], false)
    time([[Defining packer_plugins]], true)
    _G.packer_plugins = {
        ["Comment.nvim"] = {
            config = {"\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0"},
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/Comment.nvim",
            url = "https://github.com/numToStr/Comment.nvim"
        },
        ["cmp-buffer"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-buffer",
            url = "https://github.com/hrsh7th/cmp-buffer"
        },
        ["cmp-nvim-lsp"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
            url = "https://github.com/hrsh7th/cmp-nvim-lsp"
        },
        ["cmp-nvim-lsp-signature-help"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
            url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
        },
        ["cmp-path"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-path",
            url = "https://github.com/hrsh7th/cmp-path"
        },
        ["cmp-rg"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-rg",
            url = "https://github.com/lukas-reineke/cmp-rg"
        },
        ["cmp-under-comparator"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
            url = "https://github.com/lukas-reineke/cmp-under-comparator"
        },
        ["cmp-vsnip"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
            url = "https://github.com/hrsh7th/cmp-vsnip"
        },
        ["crates.nvim"] = {
            after_files = {"/Users/i98012/.local/share/nvim/site/pack/packer/opt/crates.nvim/after/plugin/cmp_crates.lua"},
            config = {"\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vcrates\frequire\0"},
            loaded = false,
            needs_bufread = false,
            only_cond = false,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/opt/crates.nvim",
            url = "https://github.com/saecki/crates.nvim"
        },
        ["gitsigns.nvim"] = {
            config = {"\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0"},
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
            url = "https://github.com/lewis6991/gitsigns.nvim"
        },
        harpoon = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/harpoon",
            url = "https://github.com/ThePrimeagen/harpoon"
        },
        ["hlargs.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/hlargs.nvim",
            url = "https://github.com/m-demare/hlargs.nvim"
        },
        ["impatient.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/impatient.nvim",
            url = "https://github.com/lewis6991/impatient.nvim"
        },
        ["inlay-hints.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/inlay-hints.nvim",
            url = "https://github.com/simrat39/inlay-hints.nvim"
        },
        ["leap.nvim"] = {
            config = {"\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0"},
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/leap.nvim",
            url = "https://github.com/ggandor/leap.nvim"
        },
        ["mason-lspconfig.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
            url = "https://github.com/williamboman/mason-lspconfig.nvim"
        },
        ["mason.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/mason.nvim",
            url = "https://github.com/williamboman/mason.nvim"
        },
        mru = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/mru",
            url = "https://github.com/yegappan/mru"
        },
        ["neo-tree.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
            url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
        },
        ["noice.nvim"] = {
            config = {"\27LJ\2\n�\2\0\0\5\0\f\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\b\0=\3\t\2B\0\2\0016\0\0\0'\2\n\0B\0\2\0029\0\v\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\fpresets\1\0\5\18bottom_search\2\20command_palette\2\26long_message_to_split\2\15inc_rename\1\19lsp_doc_border\1\blsp\1\0\0\roverride\1\0\0\1\0\3 cmp.entry.get_documentation\0021vim.lsp.util.convert_input_to_markdown_lines\2\"vim.lsp.util.stylize_markdown\2\nsetup\nnoice\frequire\0"},
            loaded = false,
            needs_bufread = false,
            only_cond = false,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/opt/noice.nvim",
            url = "https://github.com/folke/noice.nvim"
        },
        ["nui.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nui.nvim",
            url = "https://github.com/MunifTanjim/nui.nvim"
        },
        ["nvim-autopairs"] = {
            config = {"\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0"},
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
            url = "https://github.com/windwp/nvim-autopairs"
        },
        ["nvim-cmp"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-cmp",
            url = "https://github.com/hrsh7th/nvim-cmp"
        },
        ["nvim-lspconfig"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
            url = "https://github.com/neovim/nvim-lspconfig"
        },
        ["nvim-notify"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-notify",
            url = "https://github.com/rcarriga/nvim-notify"
        },
        ["nvim-treesitter"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
            url = "https://github.com/nvim-treesitter/nvim-treesitter"
        },
        ["nvim-treesitter-context"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
            url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
        },
        ["nvim-web-devicons"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
            url = "https://github.com/kyazdani42/nvim-web-devicons"
        },
        ["oxocarbon.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/oxocarbon.nvim",
            url = "https://github.com/nyoom-engineering/oxocarbon.nvim"
        },
        ["packer.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/packer.nvim",
            url = "https://github.com/wbthomason/packer.nvim"
        },
        ["plenary.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/plenary.nvim",
            url = "https://github.com/nvim-lua/plenary.nvim"
        },
        ["rust-tools.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
            url = "https://github.com/simrat39/rust-tools.nvim"
        },
        ["telescope-fzf-native.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
            url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
        },
        ["telescope-mru.nvim"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/telescope-mru.nvim",
            url = "https://github.com/alan-w-255/telescope-mru.nvim"
        },
        ["telescope.nvim"] = {
            config = {"\27LJ\2\n�\2\0\0\5\0\14\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\t\0005\4\b\0=\4\n\3=\3\v\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\n\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\r\0B\0\2\1K\0\1\0\bmru\19load_extension\15extensions\bfzf\1\0\0\1\0\4\nfuzzy\2\14case_mode\15smart_case\28override_generic_sorter\2\25override_file_sorter\2\fpickers\1\0\0\19lsp_references\1\0\0\1\0\1\14show_line\1\nsetup\14telescope\frequire\0"},
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/telescope.nvim",
            url = "https://github.com/nvim-telescope/telescope.nvim"
        },
        undotree = {
            loaded = false,
            needs_bufread = false,
            only_cond = false,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/opt/undotree",
            url = "https://github.com/mbbill/undotree"
        },
        ["vim-test"] = {
            loaded = true,
            path = "/Users/i98012/.local/share/nvim/site/pack/packer/start/vim-test",
            url = "https://github.com/vim-test/vim-test"
        }
    }

    time([[Defining packer_plugins]], false)
    -- Config for: Comment.nvim
    time([[Config for Comment.nvim]], true)
    try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0",
        "config", "Comment.nvim")
    time([[Config for Comment.nvim]], false)
    -- Config for: nvim-autopairs
    time([[Config for nvim-autopairs]], true)
    try_loadstring(
        "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0",
        "config", "nvim-autopairs")
    time([[Config for nvim-autopairs]], false)
    -- Config for: telescope.nvim
    time([[Config for telescope.nvim]], true)
    try_loadstring(
        "\27LJ\2\n�\2\0\0\5\0\14\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\t\0005\4\b\0=\4\n\3=\3\v\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\n\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\r\0B\0\2\1K\0\1\0\bmru\19load_extension\15extensions\bfzf\1\0\0\1\0\4\nfuzzy\2\14case_mode\15smart_case\28override_generic_sorter\2\25override_file_sorter\2\fpickers\1\0\0\19lsp_references\1\0\0\1\0\1\14show_line\1\nsetup\14telescope\frequire\0",
        "config", "telescope.nvim")
    time([[Config for telescope.nvim]], false)
    -- Config for: gitsigns.nvim
    time([[Config for gitsigns.nvim]], true)
    try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0",
        "config", "gitsigns.nvim")
    time([[Config for gitsigns.nvim]], false)
    -- Config for: leap.nvim
    time([[Config for leap.nvim]], true)
    try_loadstring(
        "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25add_default_mappings\tleap\frequire\0",
        "config", "leap.nvim")
    time([[Config for leap.nvim]], false)
    vim.cmd [[augroup packer_load_aucmds]]
    vim.cmd [[au!]]
    -- Event lazy-loads
    time([[Defining lazy-load event autocommands]], true)
    vim.cmd [[au BufRead Cargo.toml ++once lua require("packer.load")({'crates.nvim'}, { event = "BufRead Cargo.toml" }, _G.packer_plugins)]]
    vim.cmd [[au VimEnter * ++once lua require("packer.load")({'noice.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
    vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'undotree'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
    time([[Defining lazy-load event autocommands]], false)
    vim.cmd("augroup END")

    _G._packer.inside_compile = false
    if _G._packer.needs_bufread == true then
        vim.cmd("doautocmd BufRead")
    end
    _G._packer.needs_bufread = false

    if should_profile then
        save_profiles()
    end

end)

if not no_errors then
    error_msg = error_msg:gsub('"', '\\"')
    vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: ' .. error_msg ..
                             '" | echom "Please check your config for correctness" | echohl None')
end
