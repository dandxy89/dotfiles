-- rust-analyzer extras (replaces ferris.nvim)

local function scratch(lines, ft)
  vim.cmd('botright new')
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = ft or ''
  vim.bo[buf].buftype, vim.bo[buf].bufhidden, vim.bo[buf].modifiable = 'nofile', 'wipe', false
end

---@param method string
---@param handler fun(result: any)
local function request(method, handler)
  return function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = 'rust_analyzer' })[1]
    if not client then
      vim.notify('rust_analyzer is not attached', vim.log.levels.WARN)
      return
    end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request(method, params, function(err, result)
      if err or not result then
        vim.notify(err and err.message or ('No result for ' .. method), vim.log.levels.WARN)
        return
      end
      handler(result)
    end, 0)
  end
end

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = 0, desc = desc })
end

map(
  '<Leader>em',
  request('rust-analyzer/expandMacro', function(result)
    scratch(vim.split(result.expansion, '\n'), 'rust')
  end),
  'Expand macro'
)

map(
  '<Leader>od',
  request('experimental/externalDocs', function(result)
    vim.ui.open(type(result) == 'table' and (result.web or result['local']) or result)
  end),
  'Open documentation'
)

-- Nodes arrive as a flat array with parent_idx back-references; indent by depth.
map(
  '<Leader>ml',
  request('rust-analyzer/viewRecursiveMemoryLayout', function(result)
    local depth, lines = {}, {}
    for i, node in ipairs(result.nodes) do
      depth[i] = node.parent_idx >= 0 and depth[node.parent_idx + 1] + 1 or 0
      lines[i] = ('%s%s: %s  size=%d align=%d offset=%d'):format(('  '):rep(depth[i]), node.item_name, node.typename, node.size, node.alignment, node.offset)
    end
    scratch(lines)
  end),
  'Memory layout'
)
