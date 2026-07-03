---@class StatusComponent
---@field text string
---@field group string

---@class StatusHighlight
---@field group string
---@field start number
---@field finish number

vim.opt.statusline = ' '
local ns_id = vim.api.nvim_create_namespace('StatusLineNS')

local StatusLine = {}

StatusLine.config = {
  ignored = {
    names = { ['[LSP Eldoc]'] = true, ['NvimTree_1'] = true, ['No Name'] = true },
    buftypes = { ['nofile'] = true, ['nowrite'] = true, ['prompt'] = true, ['popup'] = true, ['terminal'] = true },
    filetypes = { ['fugitive'] = true, ['oil'] = true, ['snacks_dashboard'] = true },
  },
  colors = require('theme.colors').dark,
  diff = {
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  },
  lsp_errors = {
    symbols = { hint = ' ', warn = ' ', error = ' ' },
  },
  border_style = { ' ', '─', '', '', '', '', '', '' },
}

StatusLine.state = {
  wins = {},
  update_timer = nil, -- Debounce timer
}

function StatusLine.setup_highlights()
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'None', fg = 'None' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'None', fg = 'None' })

  vim.api.nvim_set_hl(0, 'StatusLineFilename', { fg = StatusLine.config.colors.fg, bg = 'None', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineFilenameEdited', { fg = StatusLine.config.colors.yellow, bg = 'None', bold = true })
  vim.api.nvim_set_hl(0, 'StatusLineFilenameRO', { fg = StatusLine.config.colors.red, bg = 'None', bold = true })

  vim.api.nvim_set_hl(0, 'StatusLineGitBranch', { fg = StatusLine.config.colors.violet, bg = 'None', bold = true })

  vim.api.nvim_set_hl(0, 'StatusLineDiffAdd', { fg = StatusLine.config.colors.green, bg = 'None' })
  vim.api.nvim_set_hl(0, 'StatusLineDiffChange', { fg = StatusLine.config.colors.orange, bg = 'None' })
  vim.api.nvim_set_hl(0, 'StatusLineDiffDelete', { fg = StatusLine.config.colors.red, bg = 'None' })

  vim.api.nvim_set_hl(0, 'StatusLineDiagError', { fg = StatusLine.config.colors.red, bg = 'None' })
  vim.api.nvim_set_hl(0, 'StatusLineDiagWarn', { fg = StatusLine.config.colors.yellow, bg = 'None' })
  vim.api.nvim_set_hl(0, 'StatusLineDiagInfo', { fg = StatusLine.config.colors.cyan, bg = 'None' })
end

---@param buf_id number
---@return boolean
function StatusLine.is_ignored(buf_id)
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ':t')
  local buftype = vim.bo[buf_id].buftype
  local filetype = vim.bo[buf_id].filetype

  if StatusLine.config.ignored.names[name] then
    return true
  end
  if StatusLine.config.ignored.buftypes[buftype] then
    return true
  end
  if StatusLine.config.ignored.filetypes[filetype] then
    return true
  end
  return false
end

-- Maps mode to a colour *name* (resolved at call time) so a colour refresh
-- on ColorScheme is picked up without rebuilding this table.
local mode_color_names = {
  n = 'blue',
  i = 'green',
  v = 'red',
  ['\22'] = 'red',
  V = 'red',
  c = 'magenta',
  no = 'red',
  s = 'orange',
  S = 'orange',
  ['\19'] = 'orange',
  ic = 'yellow',
  R = 'violet',
  Rv = 'violet',
  cv = 'red',
  ce = 'red',
  r = 'cyan',
  rm = 'cyan',
  ['r?'] = 'cyan',
  ['!'] = 'red',
  t = 'red',
}

---@return string
function StatusLine.get_mode_color()
  local c = StatusLine.config.colors
  return c[mode_color_names[vim.fn.mode()]] or c.blue
end

---@param buf_id number
---@return StatusComponent[]
function StatusLine.get_git_branch(buf_id)
  local signs = vim.b[buf_id].gitsigns_status_dict
  local text = signs and ('  ' .. (signs.head or '') .. ' ') or ''
  return { { text = text, group = 'StatusLineGitBranch' } }
end

---@param buf_id number
---@return StatusComponent[]
function StatusLine.get_git_diff(buf_id)
  local signs = vim.b[buf_id].gitsigns_status_dict
  if not signs then
    return {}
  end

  local config = StatusLine.config.diff
  local parts = { { text = ' ', group = 'None' } }

  if (signs.added or 0) > 0 then
    table.insert(parts, { text = config.symbols.added .. signs.added .. ' ', group = 'StatusLineDiffAdd' })
  end
  if (signs.changed or 0) > 0 then
    table.insert(parts, { text = config.symbols.modified .. signs.changed .. ' ', group = 'StatusLineDiffChange' })
  end
  if (signs.removed or 0) > 0 then
    table.insert(parts, { text = config.symbols.removed .. signs.removed .. ' ', group = 'StatusLineDiffDelete' })
  end

  return parts
end

---@param buf_id number
---@return StatusComponent[]
function StatusLine.get_diagnostics(buf_id)
  local count = vim.diagnostic.count(buf_id)
  local parts = { { text = ' ', group = 'None' } }
  local sym = StatusLine.config.lsp_errors.symbols
  local sev = vim.diagnostic.severity

  local hint_count = count[sev.HINT] or 0
  local warn_count = count[sev.WARN] or 0
  local error_count = count[sev.ERROR] or 0

  if hint_count > 0 then
    table.insert(parts, { text = sym.hint .. hint_count .. ' ', group = 'StatusLineDiagInfo' })
  end
  if warn_count > 0 then
    table.insert(parts, { text = sym.warn .. warn_count .. ' ', group = 'StatusLineDiagWarn' })
  end
  if error_count > 0 then
    table.insert(parts, { text = sym.error .. error_count .. ' ', group = 'StatusLineDiagError' })
  end

  return parts
end

---@param buf_id number
---@return {icon: StatusComponent, name: StatusComponent}
function StatusLine.get_file_info(buf_id)
  local full_path = vim.api.nvim_buf_get_name(buf_id)
  local filename = vim.fn.fnamemodify(full_path, ':.')
  local tail = vim.fn.fnamemodify(full_path, ':t')

  if filename == '' then
    filename = '[No Name]'
  end

  -- Safely get file icon with fallback
  local icon_symbol, icon_hl_group = '', 'Normal'
  local ok, mini_icons = pcall(require, 'mini.icons')
  if ok then
    local icon_ok, symbol, hl_group = pcall(mini_icons.get, 'file', tail)
    if icon_ok then
      icon_symbol, icon_hl_group = symbol, hl_group
    end
  end

  local icon = { text = ' ' .. icon_symbol .. ' ', group = icon_hl_group }
  local name = { text = ' ' .. filename .. ' ', group = 'StatusLineFilename' }

  if vim.bo[buf_id].modified then
    name.text = name.text .. '󰏫 '
    name.group = 'StatusLineFilenameEdited'
  elseif vim.bo[buf_id].readonly then
    name.text = name.text .. '󰏮 '
    name.group = 'StatusLineFilenameRO'
  end

  return {
    icon = icon,
    name = name,
  }
end

---@param buf_id number
---@param width number
---@return string content
---@return StatusHighlight[] highlights
function StatusLine.generate_content(buf_id, width)
  local left_components = {}
  local right_components = {}

  -- A. Build Left Side
  local file = StatusLine.get_file_info(buf_id)
  table.insert(left_components, file.icon)
  table.insert(left_components, file.name)

  local diffs = StatusLine.get_git_diff(buf_id)
  for _, d in ipairs(diffs) do
    table.insert(left_components, d)
  end

  -- B. Build Right Side
  local diags = StatusLine.get_diagnostics(buf_id)
  for _, d in ipairs(diags) do
    table.insert(right_components, d)
  end

  local branch = StatusLine.get_git_branch(buf_id)
  for _, b in ipairs(branch) do
    table.insert(right_components, b)
  end

  -- C. Calculate Spacer
  local left_len = 0
  for _, c in ipairs(left_components) do
    left_len = left_len + vim.api.nvim_strwidth(c.text)
  end

  local right_len = 0
  for _, c in ipairs(right_components) do
    right_len = right_len + vim.api.nvim_strwidth(c.text)
  end

  local space_len = width - left_len - right_len
  local spacer_text = string.rep(' ', math.max(space_len, 1))

  -- D. Assemble and Track Highlights
  local full_text = ''
  local highlights = {}

  local function add_components(list)
    for _, comp in ipairs(list) do
      local start_pos = #full_text
      full_text = full_text .. comp.text
      local end_pos = #full_text
      if comp.group then
        table.insert(highlights, { group = comp.group, start = start_pos, finish = end_pos })
      end
    end
  end

  add_components(left_components)
  full_text = full_text .. spacer_text -- Add spacer (no highlight)
  add_components(right_components)

  return full_text, highlights
end

---@param parent_win number
---@param buf_id number
function StatusLine.render_window(parent_win, buf_id)
  -- Safely check if window config is floating
  local config_ok, config = pcall(vim.api.nvim_win_get_config, parent_win)
  if not config_ok or (config and config.relative ~= '') or StatusLine.is_ignored(buf_id) then
    if StatusLine.state.wins[parent_win] then
      pcall(vim.api.nvim_win_close, StatusLine.state.wins[parent_win], true)
      StatusLine.state.wins[parent_win] = nil
    end
    return
  end

  -- Safely get window dimensions
  local width_ok, width = pcall(vim.api.nvim_win_get_width, parent_win)
  local height_ok, height = pcall(vim.api.nvim_win_get_height, parent_win)
  if not width_ok or not height_ok then
    return
  end

  local is_active = vim.api.nvim_get_current_win() == parent_win

  -- Position statusline: at bottom for active window, one line above for inactive
  -- This creates a visual distinction between active and inactive windows
  local row = is_active and height or (height - 1)

  local content, highlights = StatusLine.generate_content(buf_id, width)

  local status_win = StatusLine.state.wins[parent_win]
  local status_buf

  local opts = {
    relative = 'win',
    win = parent_win,
    width = width,
    height = 1,
    row = row,
    col = 0,
    border = StatusLine.config.border_style,
    style = 'minimal',
    focusable = false,
    zindex = 10, -- Low zindex to stay behind most floating windows (default is 50)
  }

  if status_win and vim.api.nvim_win_is_valid(status_win) then
    status_buf = vim.api.nvim_win_get_buf(status_win)
    vim.api.nvim_win_set_config(status_win, opts)
  else
    status_buf = vim.api.nvim_create_buf(false, true)
    status_win = vim.api.nvim_open_win(status_buf, false, opts)
    StatusLine.state.wins[parent_win] = status_win
  end

  vim.api.nvim_buf_set_lines(status_buf, 0, -1, false, { content })

  vim.api.nvim_buf_clear_namespace(status_buf, ns_id, 0, -1)
  for _, hl in ipairs(highlights) do
    vim.hl.range(status_buf, ns_id, hl.group, { 0, hl.start }, { 0, hl.finish })
  end

  local border_group = StatusLine.render_window_border_group(is_active)
  vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal,FloatBorder:' .. border_group, { win = status_win })
end

---@param is_active boolean
---@return string highlight group for the statusline border
function StatusLine.render_window_border_group(is_active)
  if not is_active then
    return 'Comment'
  end

  local mode = vim.api.nvim_get_mode().mode
  if mode == '\22' then
    mode = 'VBlock'
  end
  if mode == '\19' then
    mode = 'SBlock'
  end

  local hl_name = 'StatusBorderActive' .. mode
  vim.api.nvim_set_hl(0, hl_name, { fg = StatusLine.get_mode_color() })
  return hl_name
end

function StatusLine.update()
  if not StatusLine.state.update_timer then
    StatusLine.state.update_timer = vim.uv.new_timer()
  end
  StatusLine.state.update_timer:stop()
  StatusLine.state.update_timer:start(
    20,
    0,
    vim.schedule_wrap(function()
      -- Clean up invalid windows
      for parent, status in pairs(StatusLine.state.wins) do
        if not vim.api.nvim_win_is_valid(parent) then
          if vim.api.nvim_win_is_valid(status) then
            vim.api.nvim_win_close(status, true)
          end
          StatusLine.state.wins[parent] = nil
        end
      end

      -- Render all visible windows
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) then
          StatusLine.render_window(win, vim.api.nvim_win_get_buf(win))
        end
      end
    end)
  )
end

-- Auto-scroll the window when cursor is at the last line and near the bottom
-- This prevents the statusline from obscuring the cursor position
function StatusLine.autoscroll()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local last_line = vim.api.nvim_buf_line_count(0)

  -- Early exit: only act when cursor is on the last line (avoids work 99% of the time)
  if current_line ~= last_line then
    return
  end

  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    return
  end

  local win_height = vim.api.nvim_win_get_height(win)
  local cursor_win_line = vim.fn.winline()
  if math.abs(cursor_win_line - win_height) <= 1 then
    vim.cmd('normal! \5') -- \5 is CTRL-E (Scroll window down one line)
  end
end

StatusLine.setup_highlights()

local grp = vim.api.nvim_create_augroup('CustomStatusLine', { clear = true })

vim.api.nvim_create_autocmd(
  { 'WinEnter', 'WinClosed', 'VimResized', 'WinScrolled', 'BufEnter', 'CursorHold', 'ModeChanged' },
  { group = grp, callback = StatusLine.update }
)

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { group = grp, callback = StatusLine.autoscroll })

-- Re-extract palette and rebuild highlights if the colorscheme changes at runtime
vim.api.nvim_create_autocmd('ColorScheme', {
  group = grp,
  callback = function()
    require('theme.colors').refresh()
    StatusLine.setup_highlights()
    StatusLine.update()
  end,
})

return StatusLine
