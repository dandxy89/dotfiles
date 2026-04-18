return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({})

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, 'blink.cmp')
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end
      vim.lsp.config('*', { capabilities = capabilities })

      local disabled = { ty = true }
      local server_names = {}
      for file in vim.fs.dir(vim.fn.stdpath('config') .. '/lsp') do
        local name = file:match('(.+)%.lua$')
        if name and not disabled[name] then
          table.insert(server_names, name)
        end
      end
      vim.lsp.enable(server_names)

      local signs = { ERROR = '', WARN = '', HINT = '', INFO = '' }
      local numhl, text = {}, {}
      for name, icon in pairs(signs) do
        local severity = vim.diagnostic.severity[name]
        numhl[severity] = 'DiagnosticSign' .. name:sub(1, 1):upper() .. name:sub(2):lower()
        text[severity] = icon
      end
      vim.diagnostic.config({
        signs = { numhl = numhl, text = text },
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = '●' },
        underline = true,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
      })

      vim.api.nvim_create_user_command('LspInfo', function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local lines = { 'LSP clients attached to buffer ' .. vim.api.nvim_get_current_buf() .. ':\n' }
        if #clients == 0 then
          table.insert(lines, '  No LSP clients attached')
        else
          for _, client in ipairs(clients) do
            table.insert(lines, string.format('  - %s (ID: %d)', client.name, client.id))
            table.insert(lines, string.format('    Root: %s', client.root_dir or 'N/A'))
            table.insert(lines, string.format('    Filetypes: %s', table.concat(client.config.filetypes or {}, ', ')))
          end
        end
        vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
      end, {})

      vim.api.nvim_create_user_command('LspConfigured', function()
        local lines = { 'Configured LSP servers:\n' }
        for _, name in ipairs(server_names) do
          table.insert(lines, '  - ' .. name)
        end
        vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
      end, {})
    end,
  },

  {
    'chrisgrieser/nvim-lsp-endhints',
    event = { 'LspAttach' },
    config = function()
      require('lsp-endhints').setup({})
    end,
  },
}
