-- Extract colors from the current colorscheme
local M = {}

local function get_hl_color(group, attr)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if hl[attr] then
    return string.format('#%06x', hl[attr])
  end
  return nil
end

-- Fallback colors if highlight groups don't exist
local fallback = {
  bg = '#1e1e1e',
  bg_alt = '#252525',
  fg = '#d4d4d4',
  red = '#f44747',
  green = '#4ec9b0',
  yellow = '#ffcc66',
  blue = '#569cd6',
  magenta = '#c586c0',
  cyan = '#4fc1ff',
  orange = '#ce9178',
  violet = '#b267e6',
  dark_blue = '#264f78',
}

M.dark = {
  bg = get_hl_color('Normal', 'bg') or fallback.bg,
  bg_alt = get_hl_color('StatusLine', 'bg') or fallback.bg_alt,
  fg = get_hl_color('Normal', 'fg') or fallback.fg,
  red = get_hl_color('ErrorMsg', 'fg') or fallback.red,
  green = get_hl_color('String', 'fg') or fallback.green,
  yellow = get_hl_color('WarningMsg', 'fg') or fallback.yellow,
  blue = get_hl_color('Function', 'fg') or fallback.blue,
  magenta = get_hl_color('Statement', 'fg') or fallback.magenta,
  cyan = get_hl_color('Special', 'fg') or fallback.cyan,
  orange = get_hl_color('Number', 'fg') or fallback.orange,
  violet = get_hl_color('Type', 'fg') or fallback.violet,
  dark_blue = get_hl_color('CursorLine', 'bg') or fallback.dark_blue,
}

return M
