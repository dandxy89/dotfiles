-- LSP progress tracking utility
local M = {}

M.spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
M.progress = vim.defaulttable()

---@class LspProgressValue
---@field kind? 'begin'|'report'|'end'
---@field percentage? number
---@field title? string
---@field message? string

-- Format progress message
---@param value LspProgressValue
---@return string
local function format_message(value)
  local percentage = value.kind == 'end' and 100 or value.percentage or 100
  local title = value.title or ''
  local message = value.message and (' **%s**'):format(value.message) or ''
  return ('[%3d%%] %s%s'):format(percentage, title, message)
end

-- Get current spinner frame
---@return string
local function get_spinner_frame()
  return M.spinner_frames[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #M.spinner_frames + 1]
end

-- Update progress for a client
---@param client_id number
---@param token string|number
---@param value LspProgressValue
function M.update(client_id, token, value)
  local client = vim.lsp.get_client_by_id(client_id)
  if not client or type(value) ~= 'table' then
    return
  end

  local p = M.progress[client_id]

  -- Find or create progress entry
  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == token then
      p[i] = {
        token = token,
        msg = format_message(value),
        done = value.kind == 'end',
      }
      break
    end
  end

  -- Build message list and filter out completed items
  local messages = {}
  M.progress[client_id] = vim.tbl_filter(function(v)
    table.insert(messages, v.msg)
    return not v.done
  end, p)

  -- Notify with spinner
  local ok, _ = pcall(vim.notify, table.concat(messages, '\n'), 'info', {
    id = 'lsp_progress',
    title = client.name,
    opts = function(notif)
      notif.icon = #M.progress[client_id] == 0 and ' ' or get_spinner_frame()
    end,
  })

  if not ok then
    -- Fallback if notification fails
    vim.api.nvim_echo({ { client.name .. ': ' .. table.concat(messages, ', '), 'Normal' } }, false, {})
  end
end

return M
