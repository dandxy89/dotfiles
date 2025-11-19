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
  colors = (function()
    local p = require('theme.colors').dark
    return {
      bg = p.bg_alt,
      fg = p.fg,
      yellow = p.yellow,
      cyan = p.cyan,
      darkblue = p.dark_blue,
      green = p.green,
      orange = p.orange,
      violet = p.violet,
      magenta = p.magenta,
      blue = p.blue,
      red = p.red,
    }
  end)(),
  diff = {
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  },
  lsp_errors = {
    symbols = { info = ' ', warn = ' ', error = ' ' },
  },
  border_style = { ' ', '─', '', '', '', '', '', '' },
}

StatusLine.state = {
  wins = {},
  cache = {}, -- Cache for rendered content
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

---Generate a cache key for a window/buffer combination
---@param win_id number
---@param buf_id number
---@param width number
---@return string
function StatusLine.cache_key(win_id, buf_id, width)
  local mode = vim.api.nvim_get_mode().mode

  -- Safely access buffer options
  local modified_ok, modified = pcall(function() return vim.bo[buf_id].modified end)
  if not modified_ok then modified = false end

  local readonly_ok, readonly = pcall(function() return vim.bo[buf_id].readonly end)
  if not readonly_ok then readonly = false end

  -- Include diagnostic and git status in cache key
  local diag_count = vim.diagnostic.count(buf_id)
  local diag_key = string.format('%d,%d,%d',
    diag_count[vim.diagnostic.severity.ERROR] or 0,
    diag_count[vim.diagnostic.severity.WARN] or 0,
    diag_count[vim.diagnostic.severity.HINT] or 0
  )

  local git_key = ''
  local ok, signs = pcall(function() return vim.b[buf_id].gitsigns_status_dict end)
  if ok and signs then
    git_key = string.format('%s,%d,%d,%d',
      signs.head or '',
      signs.added or 0,
      signs.changed or 0,
      signs.removed or 0
    )
  end

  return string.format('%d:%d:%d:%s:%s:%s:%s:%s',
    win_id, buf_id, width, mode, tostring(modified), tostring(readonly), diag_key, git_key
  )
end

---@return string
function StatusLine.get_mode_color()
  local m = vim.fn.mode()
  local c = StatusLine.config.colors
  local map = {
    n = c.blue,
    i = c.green,
    v = c.red,
    ['\22'] = c.red,
    V = c.red,
    c = c.magenta,
    no = c.red,
    s = c.orange,
    S = c.orange,
    ['\19'] = c.orange,
    ic = c.yellow,
    R = c.violet,
    Rv = c.violet,
    cv = c.red,
    ce = c.red,
    r = c.cyan,
    rm = c.cyan,
    ['r?'] = c.cyan,
    ['!'] = c.red,
    t = c.red,
  }
  return map[m] or c.blue
end

---@param buf_id number
---@return StatusComponent[]
function StatusLine.get_git_branch(buf_id)
  -- Safely access gitsigns buffer variable
  local ok, signs = pcall(function() return vim.b[buf_id].gitsigns_status_dict end)
  if not ok then signs = nil end

  local text = signs and ('  ' .. (signs.head or '') .. ' ') or ''
  return { { text = text, group = 'StatusLineGitBranch' } }
end

---@param buf_id number
---@return StatusComponent[]
function StatusLine.get_git_diff(buf_id)
  -- Safely access gitsigns buffer variable
  local ok, signs = pcall(function() return vim.b[buf_id].gitsigns_status_dict end)
  if not ok or not signs then
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
    table.insert(parts, { text = sym.info .. hint_count .. ' ', group = 'StatusLineDiagInfo' })
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

  -- Safely check buffer options
  local modified_ok, modified = pcall(function() return vim.bo[buf_id].modified end)
  local readonly_ok, readonly = pcall(function() return vim.bo[buf_id].readonly end)

  if modified_ok and modified then
    name.text = name.text .. '󰏫 '
    name.group = 'StatusLineFilenameEdited'
  elseif readonly_ok and readonly then
    name.text = name.text .. '󰏮 '
    name.group = 'StatusLineFilenameRO'
  end

  return {
    icon = icon,
    name = name,
  }
end

---@param win_id number
---@param buf_id number
---@param width number
---@return string content
---@return StatusHighlight[] highlights
function StatusLine.generate_content(win_id, buf_id, width)
  -- Check cache first
  local key = StatusLine.cache_key(win_id, buf_id, width)
  if StatusLine.state.cache[key] then
    return StatusLine.state.cache[key].content, StatusLine.state.cache[key].highlights
  end

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
    left_len = left_len + vim.fn.strdisplaywidth(c.text)
  end

  local right_len = 0
  for _, c in ipairs(right_components) do
    right_len = right_len + vim.fn.strdisplaywidth(c.text)
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

  -- Store in cache
  StatusLine.state.cache[key] = {
    content = full_text,
    highlights = highlights,
  }

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

  local content, highlights = StatusLine.generate_content(parent_win, buf_id, width)

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

  local border_group = 'Comment'
  if is_active then
    local mode = vim.api.nvim_get_mode().mode
    if mode == '\22' then
      mode = 'VBlock'
    end
    if mode == '\19' then
      mode = 'SBlock'
    end

    local hl_name = 'StatusBorderActive' .. mode
    vim.api.nvim_set_hl(0, hl_name, { fg = StatusLine.get_mode_color() })
    border_group = hl_name
  end

  vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal,FloatBorder:' .. border_group, { win = status_win })
end

function StatusLine.update()
  -- Debounce updates to avoid excessive redraws
  -- 20ms provides a good balance between responsiveness and performance
  if StatusLine.state.update_timer then
    vim.fn.timer_stop(StatusLine.state.update_timer)
  end

  StatusLine.state.update_timer = vim.fn.timer_start(20, function()
    vim.schedule(function()
      -- Clear cache when it grows beyond 100 entries to prevent memory growth
      -- This rarely happens in practice but prevents edge cases with many windows/buffers
      if vim.tbl_count(StatusLine.state.cache) > 100 then
        StatusLine.state.cache = {}
      end

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
  end)
end

-- Auto-scroll the window when cursor is at the last line and near the bottom
-- This prevents the statusline from obscuring the cursor position
function StatusLine.autoscroll()
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    return
  end

  local current_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')

  if current_line == last_line then
    local win_height = vim.api.nvim_win_get_height(win)
    local cursor_win_line = vim.fn.winline()
    -- Allow 1 line tolerance to account for the statusline overlay
    if math.abs(cursor_win_line - win_height) <= 1 then
      vim.cmd('normal! \5') -- \5 is CTRL-E (Scroll window down one line)
    end
  end
end

StatusLine.setup_highlights()

local grp = vim.api.nvim_create_augroup('CustomStatusLine', { clear = true })

vim.api.nvim_create_autocmd(
  { 'WinEnter', 'WinClosed', 'VimResized', 'WinScrolled', 'BufEnter', 'CursorHold', 'ModeChanged' },
  { group = grp, callback = StatusLine.update }
)

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { group = grp, callback = StatusLine.autoscroll })

return StatusLine
