-- Outdated-dependency hints for pyproject.toml (PyPI) and Cargo.toml (crates.io).
-- Virtual text at end of line shows the latest version; `<leader>cv` picks a version to write into the spec.

---@alias deps.Eco 'pypi'|'crates'

---@class deps.Index
---@field name string
---@field url string
---@field default? true

---@class deps.Dep
---@field lnum integer 0-based
---@field name string
---@field spec string version as written in the spec, e.g. `1.0` or `2.31`
---@field index? deps.Index private uv index, if any

---@class deps.Info
---@field latest string
---@field versions string[] stable versions, newest first

local M = {}
local ns = vim.api.nvim_create_namespace('deps')
local cache = {} ---@type table<string, deps.Info>
local UA = 'nvim-deps'

---@param v string
---@return integer[]
local function nums(v)
  local t = {}
  for n in v:gmatch('%d+') do
    t[#t + 1] = tonumber(n)
  end
  return t
end

--- Outdated when the leading components of the spec differ from the latest
--- (so Cargo "1.0" is current at 1.0.200, and `>=2.31` is stale at 2.32).
---@param spec string
---@param latest string
---@return boolean
local function outdated(spec, latest)
  local s, l = nums(spec), nums(latest)
  for i = 1, #s do
    if s[i] ~= (l[i] or 0) then
      return true
    end
  end
  return false
end

---@param buf integer
---@param eco deps.Eco
---@return deps.Dep[]
local function parse(buf, eco)
  local deps, section = {}, '' ---@type deps.Dep[], string
  local indexes, sources, default = {}, {}, nil ---@type table<string, deps.Index>, table<string, string>, deps.Index?
  local cur ---@type table?
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if eco == 'pypi' then
      local hdr = line:match('^%s*(%[%[?[^%]]+%]%]?)')
      if hdr then
        section = hdr
        cur = hdr == '[[tool.uv.index]]' and {} or nil
      elseif cur then
        local k, v = line:match('^%s*([%w_-]+)%s*=%s*"([^"]*)"')
        if k then
          cur[k] = v
        end
        if line:match('^%s*default%s*=%s*true') then
          cur.default = true
        end
        if cur.name and cur.url then
          indexes[cur.name] = cur
          default = cur.default and cur or default
        end
      elseif section == '[tool.uv.sources]' then
        local pkg, idx = line:match('^%s*([%w._-]+)%s*=%s*{.-index%s*=%s*"([^"]+)"')
        if pkg then
          sources[pkg:lower():gsub('[-_.]+', '-')] = idx
        end
      end
    end
    if eco == 'crates' then
      section = line:match('^%s*%[(.-)%]') or section
      if section:match('dependencies$') then
        local name, spec = line:match('^%s*([%w_-]+)%s*=%s*"([^"]+)"')
        if not name then
          name, spec = line:match('^%s*([%w_-]+)%s*=%s*{.-version%s*=%s*"([^"]+)"')
        end
        if name and spec:match('%d') then
          deps[#deps + 1] = { lnum = i - 1, name = name, spec = spec:match('%d[%w%.]*') }
        end
      end
    else
      for str in line:gmatch('"([^"]+)"') do
        local name, spec = str:match('^([%w][%w._-]*)%s*%[?[%w,%s._-]*%]?%s*[<>=!~]+%s*(%d[%w%.]*)')
        if name then
          deps[#deps + 1] = { lnum = i - 1, name = name, spec = spec }
        end
      end
    end
  end
  for _, d in ipairs(deps) do
    d.index = indexes[sources[d.name:lower():gsub('[-_.]+', '-')] or ''] or default
  end
  return deps
end

---@param eco deps.Eco
---@param d deps.Dep
---@return string
local function cache_key(eco, d)
  return ('%s:%s:%s'):format(eco, d.index and d.index.url or '', d.name)
end

--- Version from a wheel or sdist filename.
---@param f string
---@return string?
local function file_version(f)
  return f:match('^[^-]+-([^-]+)-.*%.whl$') or f:match('^.+-(%d[^-]*)%.tar%.gz$') or f:match('^.+-(%d[^-]*)%.zip$')
end

---@param v string
---@return boolean
local function stable(v)
  return v:match('^[%d%.]+$') ~= nil
end

---@param eco deps.Eco
---@param d deps.Dep
---@param cb fun(info: deps.Info?, err: string?)
local function fetch(eco, d, cb)
  local key = cache_key(eco, d)
  if cache[key] then
    return cb(cache[key])
  end
  local cmd = { 'curl', '-sfL', '--max-time', '10', '-A', UA }
  local url
  if eco == 'crates' then
    url = ('https://crates.io/api/v1/crates/%s'):format(d.name)
  elseif d.index then
    -- Private uv index: PEP 503/691 simple API. Auth: UV_INDEX_<NAME>_USERNAME/PASSWORD, else ~/.netrc.
    local env = 'UV_INDEX_' .. d.index.name:upper():gsub('[^%w]', '_')
    local user, pass = vim.env[env .. '_USERNAME'], vim.env[env .. '_PASSWORD']
    vim.list_extend(cmd, user and { '-u', user .. ':' .. (pass or '') } or { '-n' })
    vim.list_extend(cmd, { '-H', 'Accept: application/vnd.pypi.simple.v1+json' })
    url = ('%s/%s/'):format(d.index.url:gsub('/+$', ''), d.name:lower():gsub('[-_.]+', '-'))
  else
    url = ('https://pypi.org/pypi/%s/json'):format(d.name)
  end
  cmd[#cmd + 1] = url
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        return cb(nil, ('curl exit %d'):format(res.code))
      end
      local ok, data = pcall(vim.json.decode, res.stdout)
      if not ok then
        return cb(nil, 'bad JSON')
      end
      local versions = {}
      if eco == 'pypi' then
        local found = data.releases and vim.tbl_keys(data.releases) or data.versions or {}
        if not data.releases and not data.versions then
          for _, f in ipairs(data.files or {}) do
            found[#found + 1] = file_version(f.filename)
          end
        end
        for _, v in ipairs(found) do
          if stable(v) then
            versions[#versions + 1] = v
          end
        end
        table.sort(versions, function(a, b)
          return vim.version.gt(a, b)
        end)
      else
        for _, v in ipairs(data.versions or {}) do
          if not v.yanked and stable(v.num) then
            versions[#versions + 1] = v.num
          end
        end
        table.sort(versions, function(a, b)
          return vim.version.gt(a, b)
        end)
      end
      local latest = eco == 'crates' and data.crate and data.crate.max_stable_version or data.info and data.info.version or versions[1]
      if not latest then
        return cb(nil, 'no version')
      end
      cache[key] = { latest = latest, versions = versions }
      cb(cache[key])
    end)
  end)
end

--- Re-fetch and redraw the version hints for every dependency in `buf`.
---@param buf integer
function M.refresh(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local eco = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t') == 'Cargo.toml' and 'crates' or 'pypi'
  for _, d in ipairs(parse(buf, eco)) do
    fetch(eco, d, function(info, err)
      if not vim.api.nvim_buf_is_valid(buf) or d.lnum >= vim.api.nvim_buf_line_count(buf) then
        return
      end
      local text, hl
      if not info then
        text, hl = ('  ? %s'):format(err), 'DiagnosticWarn'
      elseif outdated(d.spec, info.latest) then
        text, hl = ('  ⬆ %s'):format(info.latest), 'DiagnosticWarn'
      else
        text, hl = '  ✓ ' .. info.latest, 'DiagnosticOk'
      end
      vim.api.nvim_buf_set_extmark(buf, ns, d.lnum, 0, { virt_text = { { text, hl } }, hl_mode = 'combine' })
    end)
  end
end

--- Pick a version for the dependency on the cursor line and write it into the spec.
function M.versions()
  local buf = vim.api.nvim_get_current_buf()
  local eco = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t') == 'Cargo.toml' and 'crates' or 'pypi'
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  for _, d in ipairs(parse(buf, eco)) do
    if d.lnum == lnum then
      local info = cache[cache_key(eco, d)]
      if not info then
        return vim.notify(d.name .. ': not fetched yet', vim.log.levels.WARN)
      end
      return vim.ui.select(info.versions, { prompt = ('%s (current %s)'):format(d.name, d.spec) }, function(v)
        if not v or not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ''
        local n = line:find(d.name, 1, true)
        local s, e = line:find(d.spec, n or 1, true)
        if not s or not e then
          return vim.notify(d.name .. ': line changed, spec not found', vim.log.levels.ERROR)
        end
        vim.api.nvim_buf_set_text(buf, lnum, s - 1, lnum, e, { v })
        M.refresh(buf)
      end)
    end
  end
  vim.notify('no dependency on this line', vim.log.levels.WARN)
end

--- Show hints and map `<leader>cv` in pyproject.toml and Cargo.toml buffers.
function M.setup()
  local group = vim.api.nvim_create_augroup('Deps', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
    group = group,
    pattern = { 'pyproject.toml', 'Cargo.toml' },
    callback = function(a)
      M.refresh(a.buf)
      vim.keymap.set('n', '<leader>cv', M.versions, { buffer = a.buf, desc = 'Pick dependency version' })
    end,
  })
end

return M
