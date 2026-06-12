return {
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    dependencies = { 'nvim-treesitter-textobjects' },
    config = function()
      local ts = require('nvim-treesitter')
      local installed = ts.get_installed and ts.get_installed('parsers') or {}
      local have = {}
      for _, p in ipairs(installed) do
        have[p] = true
      end
      local wanted = {
        'bash',
        'lua',
        'rust',
        'python',
        'typescript',
        'javascript',
        'json',
        'yaml',
        'toml',
        'markdown',
        'vim',
        'proto',
        'make',
        'dockerfile',
      }
      local missing = {}
      for _, p in ipairs(wanted) do
        if not have[p] then
          table.insert(missing, p)
        end
      end
      if #missing > 0 then
        ts.install(missing)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('custom_treesitter_start', { clear = true }),
        callback = function(ev)
          local buf_name = vim.api.nvim_buf_get_name(ev.buf)
          local file_size = vim.fn.getfsize(buf_name)
          if file_size > 256 * 1024 then
            return
          end
          pcall(vim.treesitter.start, ev.buf)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true, include_surrounding_whitespace = true },
        move = { set_jumps = true },
      })

      local ts_select = require('nvim-treesitter-textobjects.select')
      local select_maps = {
        { 'aa', '@parameter.outer' },
        { 'ia', '@parameter.inner' },
        { 'af', '@function.outer' },
        { 'if', '@function.inner' },
        { 'ac', '@class.outer' },
        { 'ic', '@class.inner' },
        { 'ii', '@conditional.inner' },
        { 'ai', '@conditional.outer' },
        { 'il', '@loop.inner' },
        { 'al', '@loop.outer' },
        { 'at', '@comment.outer' },
      }
      for _, map in ipairs(select_maps) do
        vim.keymap.set({ 'x', 'o' }, map[1], function()
          ts_select.select_textobject(map[2], 'textobjects')
        end)
      end

      local ts_move = require('nvim-treesitter-textobjects.move')
      local move_maps = {
        { ']m', 'goto_next_start', '@function.outer' },
        { ']]', 'goto_next_start', '@class.outer' },
        { ']M', 'goto_next_end', '@function.outer' },
        { '][', 'goto_next_end', '@class.outer' },
        { '[m', 'goto_previous_start', '@function.outer' },
        { '[[', 'goto_previous_start', '@class.outer' },
        { '[M', 'goto_previous_end', '@function.outer' },
        { '[]', 'goto_previous_end', '@class.outer' },
      }
      for _, map in ipairs(move_maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, map[1], function()
          ts_move[map[2]](map[3], 'textobjects')
        end)
      end

      local inc_sel_node = nil
      local function select_node(node)
        local sr, sc, er, ec = node:range()
        if ec == 0 then
          er = er - 1
          ec = #vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1]
        end
        vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
        vim.api.nvim_buf_set_mark(0, '>', er + 1, math.max(ec - 1, 0), {})
        vim.cmd('normal! gv')
      end

      vim.keymap.set('n', '<C-space>', function()
        local node = vim.treesitter.get_node()
        if not node then
          return
        end
        inc_sel_node = node
        select_node(node)
      end, { desc = 'Init treesitter selection' })

      vim.keymap.set('x', '<C-space>', function()
        if not inc_sel_node then
          return
        end
        local parent = inc_sel_node:parent()
        if not parent then
          return
        end
        inc_sel_node = parent
        select_node(parent)
      end, { desc = 'Expand treesitter selection' })

      vim.keymap.set('x', '<BS>', function()
        if not inc_sel_node then
          return
        end
        local child = inc_sel_node:named_child(0)
        if not child then
          return
        end
        inc_sel_node = child
        select_node(child)
      end, { desc = 'Shrink treesitter selection' })
    end,
  },
}
