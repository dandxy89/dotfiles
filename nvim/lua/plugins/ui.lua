return {
  {
    'zitrocode/carvion.nvim',
    lazy = false,
    config = function()
      require('carvion').setup({})
      vim.cmd.colorscheme('carvion')
    end,
  },

  {
    'folke/snacks.nvim',
    lazy = false,
    config = function()
      require('snacks').setup({
        bigfile = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 1000,
          win = { backdrop = { transparent = false } },
        },
        -- statuscolumn intentionally disabled: core/opts.lua sets a minimal '%l%s'
        statuscolumn = { enabled = false },
        words = { enabled = true },
      })

      local maps = {
        {
          '<Leader>n',
          function()
            require('snacks').notifier.show_history()
          end,
          'Notification history',
        },
        {
          '<Leader>.',
          function()
            require('snacks').terminal()
          end,
          'Terminal',
        },
        {
          '<Leader>k',
          function()
            require('snacks').terminal.toggle('kiro-cli chat --v3', {
              win = { position = 'right', width = 0.4 },
            })
          end,
          'Kiro CLI',
        },
        {
          '<Leader>gB',
          function()
            require('snacks').gitbrowse()
          end,
          'Git browse',
        },
        {
          '<Leader>gb',
          function()
            require('snacks').git.blame_line()
          end,
          'Git blame line',
        },
        {
          '<Leader>gf',
          function()
            require('snacks').lazygit.log_file()
          end,
          'Git log file',
        },
        {
          '<Leader>lg',
          function()
            require('snacks').lazygit()
          end,
          'Lazygit',
        },
      }
      for _, map in ipairs(maps) do
        vim.keymap.set('n', map[1], map[2], { desc = map[3], noremap = true, silent = true })
      end
    end,
  },
}
