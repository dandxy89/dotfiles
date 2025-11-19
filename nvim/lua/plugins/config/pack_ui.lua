local Popup = require('nui.popup')
local NuiLine = require('nui.line')
local NuiText = require('nui.text')

local PackUI = {}
PackUI.__index = PackUI

-- Create a new PackUI instance
function PackUI:new(title)
  local instance = setmetatable({}, PackUI)
  instance.popup = nil
  instance.title = title or 'Plugin Manager'
  instance.plugins = {} -- { plugin_name = { status = "pending|running|success|error", message = "" } }
  instance.plugin_order = {} -- Ordered list of plugin names
  instance.progress = { completed = 0, total = 0 }
  instance.extra_lines = {} -- Extra informational lines
  instance.show_help = false -- Toggle help menu
  instance.refreshable = false -- Can this view be refreshed?
  instance.refresh_callback = nil -- Function to call on refresh
  return instance
end

-- Create and mount the popup window
function PackUI:open()
  if self.popup then
    return -- Already open
  end

  self.popup = Popup({
    position = '50%',
    size = {
      width = '85%',
      height = '80%',
    },
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = ' ' .. self.title .. ' ',
        top_align = 'center',
        bottom = ' q:quit | ?:help ',
        bottom_align = 'center',
      },
    },
    buf_options = {
      modifiable = false,
      readonly = true,
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
      cursorline = true,
      cursorlineopt = 'both',
    },
  })

  self.popup:mount()

  -- Keybindings for closing
  self.popup:map('n', 'q', function()
    self:close()
  end, { noremap = true })

  self.popup:map('n', '<Esc>', function()
    self:close()
  end, { noremap = true })

  -- Help toggle
  self.popup:map('n', '?', function()
    self.show_help = not self.show_help
    self:render()
  end, { noremap = true })

  -- Refresh keybinding
  self.popup:map('n', 'r', function()
    if self.refreshable and self.refresh_callback then
      self.refresh_callback()
    end
  end, { noremap = true })

  -- Scroll keybindings (j/k)
  self.popup:map('n', 'j', function()
    vim.cmd('normal! j')
  end, { noremap = true })

  self.popup:map('n', 'k', function()
    vim.cmd('normal! k')
  end, { noremap = true })

  -- Initial render
  self:render()
end

-- Close the popup window
function PackUI:close()
  if self.popup then
    self.popup:unmount()
    self.popup = nil
  end
end

-- Add or update a plugin's status
function PackUI:set_plugin_status(plugin_name, status, message)
  if not self.plugins[plugin_name] then
    table.insert(self.plugin_order, plugin_name)
  end

  self.plugins[plugin_name] = {
    status = status,
    message = message or '',
  }

  self:render()
end

-- Update progress counter
function PackUI:set_progress(completed, total)
  self.progress.completed = completed
  self.progress.total = total
  self:render()
end

-- Add an informational line (like summary messages)
function PackUI:add_line(text)
  table.insert(self.extra_lines, text)
  self:render()
end

-- Clear all extra lines
function PackUI:clear_extra_lines()
  self.extra_lines = {}
  self:render()
end

-- Get status icon and highlight group
local function get_status_display(status)
  if status == 'pending' then
    return '⚪', 'Comment'
  elseif status == 'running' then
    return '🔵', 'DiagnosticInfo'
  elseif status == 'success' then
    return '🟢', 'DiagnosticOk'
  elseif status == 'error' then
    return '🔴', 'DiagnosticError'
  else
    return '⚫', 'Normal'
  end
end

-- Create a progress bar visualization
local function create_progress_bar(completed, total, width)
  if total == 0 then
    return '━━━━━━━━━━━━━━━━━━━━ 0%'
  end

  local percentage = math.floor((completed / total) * 100)
  local filled = math.floor((completed / total) * width)
  local empty = width - filled

  local bar = string.rep('█', filled) .. string.rep('░', empty)
  return string.format('[%s] %d%%', bar, percentage)
end

-- Render the UI
function PackUI:render()
  if not self.popup or not vim.api.nvim_buf_is_valid(self.popup.bufnr) then
    return
  end

  local lines = {}

  -- Help menu (if toggled)
  if self.show_help then
    local help_lines = {
      {
        text = '╔════════════════════════════════════════╗',
        hl = 'FloatBorder',
      },
      { text = '║            KEYBINDINGS HELP            ║', hl = 'Title' },
      {
        text = '╠════════════════════════════════════════╣',
        hl = 'FloatBorder',
      },
      { text = '║  q / <Esc>  │  Close window            ║', hl = 'Normal' },
      { text = '║  j / k      │  Scroll down/up          ║', hl = 'Normal' },
      { text = '║  ?          │  Toggle this help        ║', hl = 'Normal' },
      { text = '║  r          │  Refresh (if available)  ║', hl = 'Normal' },
      {
        text = '╚════════════════════════════════════════╝',
        hl = 'FloatBorder',
      },
    }

    for _, help_line in ipairs(help_lines) do
      local line = NuiLine()
      line:append(help_line.text, help_line.hl)
      table.insert(lines, line)
    end

    table.insert(lines, NuiLine()) -- Empty line
  end

  -- Progress header with enhanced visualization
  if self.progress.total > 0 then
    local progress_header = NuiLine()
    progress_header:append('╭─ Progress ', 'FloatBorder')
    progress_header:append(string.format('(%d/%d)', self.progress.completed, self.progress.total), 'Special')
    progress_header:append(' ' .. string.rep('─', 50), 'FloatBorder')
    table.insert(lines, progress_header)

    local progress_bar = NuiLine()
    progress_bar:append('│ ', 'FloatBorder')
    local bar_text = create_progress_bar(self.progress.completed, self.progress.total, 40)
    local bar_color = self.progress.completed == self.progress.total and 'DiagnosticOk' or 'DiagnosticInfo'
    progress_bar:append(bar_text, bar_color)
    table.insert(lines, progress_bar)

    local separator = NuiLine()
    separator:append('╰' .. string.rep('─', 65), 'FloatBorder')
    table.insert(lines, separator)
    table.insert(lines, NuiLine()) -- Empty line
  end

  -- Plugin status list
  for _, plugin_name in ipairs(self.plugin_order) do
    local plugin_info = self.plugins[plugin_name]
    local icon, hl_group = get_status_display(plugin_info.status)

    local line = NuiLine()
    line:append('  ' .. icon .. ' ', hl_group)
    line:append(plugin_name, 'Special')

    if plugin_info.message and plugin_info.message ~= '' then
      line:append('  │  ', 'FloatBorder')
      line:append(plugin_info.message, 'Comment')
    end

    table.insert(lines, line)
  end

  -- Extra informational lines
  if #self.extra_lines > 0 then
    table.insert(lines, NuiLine()) -- Empty line

    local extra_separator = NuiLine()
    extra_separator:append('─' .. string.rep('─', 65), 'FloatBorder')
    table.insert(lines, extra_separator)

    for _, text in ipairs(self.extra_lines) do
      local line = NuiLine()
      line:append('  ' .. text, 'Comment')
      table.insert(lines, line)
    end
  end

  -- Set buffer to modifiable temporarily
  vim.api.nvim_set_option_value('modifiable', true, { buf = self.popup.bufnr })
  vim.api.nvim_set_option_value('readonly', false, { buf = self.popup.bufnr })

  -- Clear buffer and render lines
  vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, {})

  for i, line in ipairs(lines) do
    line:render(self.popup.bufnr, -1, i)
  end

  -- Set buffer back to readonly
  vim.api.nvim_set_option_value('modifiable', false, { buf = self.popup.bufnr })
  vim.api.nvim_set_option_value('readonly', true, { buf = self.popup.bufnr })

  -- Auto-scroll to bottom
  if vim.api.nvim_win_is_valid(self.popup.winid) then
    local line_count = vim.api.nvim_buf_line_count(self.popup.bufnr)
    vim.api.nvim_win_set_cursor(self.popup.winid, { line_count, 0 })
  end
end

-- Display static information (for PackStatus)
function PackUI:display_static(content_lines)
  if not self.popup then
    self:open()
  end

  if not vim.api.nvim_buf_is_valid(self.popup.bufnr) then
    return
  end

  local lines = {}

  -- Help menu (if toggled)
  if self.show_help then
    local help_lines = {
      {
        text = '╔════════════════════════════════════════╗',
        hl = 'FloatBorder',
      },
      { text = '║            KEYBINDINGS HELP            ║', hl = 'Title' },
      {
        text = '╠════════════════════════════════════════╣',
        hl = 'FloatBorder',
      },
      { text = '║  q / <Esc>  │  Close window            ║', hl = 'Normal' },
      { text = '║  j / k      │  Scroll down/up          ║', hl = 'Normal' },
      { text = '║  ?          │  Toggle this help        ║', hl = 'Normal' },
      { text = '║  r          │  Refresh (if available)  ║', hl = 'Normal' },
      {
        text = '╚════════════════════════════════════════╝',
        hl = 'FloatBorder',
      },
    }

    for _, help_line in ipairs(help_lines) do
      local line = NuiLine()
      line:append(help_line.text, help_line.hl)
      table.insert(lines, line)
    end

    table.insert(lines, NuiLine()) -- Empty line
  end

  -- Add content lines
  for _, line_content in ipairs(content_lines) do
    local line = NuiLine()
    if type(line_content) == 'table' then
      -- Expecting { text = "...", hl_group = "..." }
      line:append(line_content.text, line_content.hl_group or 'Normal')
    else
      line:append(tostring(line_content), 'Normal')
    end
    table.insert(lines, line)
  end

  -- Set buffer to modifiable temporarily
  vim.api.nvim_set_option_value('modifiable', true, { buf = self.popup.bufnr })
  vim.api.nvim_set_option_value('readonly', false, { buf = self.popup.bufnr })

  -- Clear buffer
  vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, {})

  -- Render all lines
  for i, line in ipairs(lines) do
    line:render(self.popup.bufnr, -1, i)
  end

  -- Set buffer back to readonly
  vim.api.nvim_set_option_value('modifiable', false, { buf = self.popup.bufnr })
  vim.api.nvim_set_option_value('readonly', true, { buf = self.popup.bufnr })
end

return PackUI
