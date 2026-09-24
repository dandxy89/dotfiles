-- LP language server from lp_parser_rs (`cargo install --path lsp`).
---@type vim.lsp.Config
return {
  cmd = { 'lp-lsp' },
  filetypes = { 'lp' },
  root_markers = { '.git' },
  settings = {
    lp = {
      semantic = { debounceMs = 300, maxFileSizeMb = 20 },
      format = { indent = 2, lineWidth = 100, alignOperators = false, keywordCase = 'preserve' },
      inlayHints = { generatedNames = true, rangePartners = true, variableTypes = true, normalisedRhs = true },
    },
  },
  on_attach = function(client, buf)
    local function run(command)
      return function()
        local params = { title = command, command = command, arguments = { vim.uri_from_bufnr(buf) } }
        client:exec_cmd(params, { bufnr = buf }, function(err, result)
          if err then
            return vim.notify(err.message, vim.log.levels.ERROR)
          end
          if result and result.markdown then
            vim.lsp.util.open_floating_preview(vim.split(result.markdown, '\n'), 'markdown', { border = 'rounded' })
          elseif result and result.path then
            vim.notify('Wrote ' .. result.path)
          end
        end)
      end
    end
    vim.keymap.set('n', '<Leader>ma', run('lp.analyze'), { buffer = buf, desc = 'LP: analyse model' })
    vim.keymap.set('n', '<Leader>ms', run('lp.showModelStats'), { buffer = buf, desc = 'LP: model stats' })
    vim.keymap.set('n', '<Leader>mc', run('lp.convertToMps'), { buffer = buf, desc = 'LP: convert to MPS' })
  end,
  commands = {
    -- Client-side command used by the "used in N constraints" code lens.
    ['lp.showReferences'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local locations = command.arguments[3] or {}
      local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
      vim.fn.setqflist({}, ' ', { title = 'LP references', items = items })
      vim.cmd.copen()
    end,
  },
}
