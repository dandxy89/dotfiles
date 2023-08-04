return {
  {
      "shellRaining/hlchunk.nvim",
      keys = { "<leader>u" },
      event = "InsertEnter",
      opts = function()
          require('hlchunk').setup({
            blank = {
                enable = false,
            },
            indent = {
                enable = false,
            },
            chunk = {
                chars = {
                    horizontal_line = "─",
                    vertical_line = "│",
                    left_top = "┌",
                    left_bottom = "└",
                    right_arrow = "─",
                },
                style = "#00ffff",
            },
          })
      end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
    opts = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "dockerfile",
          "hcl",
          -- "help",
          "http",
          "json",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rust",
          "toml",
          "vim",
          "yaml",
        },
        sync_install = false,
        highlight = {
          enable = true,
        },
        ident = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        autotag = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
    }
    end,
  },
  {
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      opts = function()
          require'treesitter-context'.setup{
              enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
              max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
              min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
              line_numbers = true,
              multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
              trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
              mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
              -- Separator between context and content. Should be a single character string, like '-'.
              -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
              separator = nil,
              zindex = 20, -- The Z-index of the context window
              on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        }
    end
  }
}
