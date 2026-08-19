-- Declarative plugin manager wrapping vim.pack, adapted from kite12580/pack.lua
-- Plugin specs live in lua/plugins/*.lua, each returning { {spec}, {spec}, … }

---@class PackSpec
---@field [1] string source (GitHub "org/repo" or full URL)
---@field name? string plugin name (inferred from src if omitted)
---@field version? string|vim.VersionRange passthrough to vim.pack.add
---@field lazy? boolean default true; false means load at startup
---@field dependencies? string[] plugin names; each dep must have its own spec
---@field event? string[] autocmd events ("InsertEnter" or "FileType rust")
---@field cmd? string[] user commands that trigger loading
---@field keys? table[] { mode, lhs, rhs?, opts? } — stub keymaps
---@field build? fun()|string runs after install/update; string is shell command
---@field init? fun() called before any plugin is loaded
---@field config? fun() called after this plugin is loaded

local M = {}
local specs = {} ---@type table<string, PackSpec>
local loaded = {} ---@type table<string, boolean>

---@param spec PackSpec
---@return vim.pack.Spec
local function to_pack_spec(spec)
  local src = spec[1]
  if not src:match('^https?://') then
    src = 'https://github.com/' .. src
  end
  return { src = src, name = spec.name, version = spec.version }
end

---@param name string
---@return string
local function plugin_path(name)
  return vim.fn.stdpath('data') .. '/site/pack/core/opt/' .. name
end

---@param spec PackSpec
local function run_build(spec)
  local build = spec.build
  if type(build) == 'function' then
    build()
  elseif type(build) == 'string' then
    vim.notify('Building ' .. spec.name .. '...', vim.log.levels.INFO)
    vim.system({ 'sh', '-c', build }, { cwd = plugin_path(spec.name) }, function(obj)
      vim.schedule(function()
        if obj.code ~= 0 then
          vim.notify('Build failed for ' .. spec.name .. ':\n' .. (obj.stderr or obj.stdout or ''), vim.log.levels.ERROR)
        else
          vim.notify('Built ' .. spec.name, vim.log.levels.INFO)
        end
      end)
    end)
  end
end

---@param spec PackSpec
---@param defer? boolean packadd with bang (defer sourcing until startup completes)
local function load_plugin(spec, defer)
  if loaded[spec.name] then
    return
  end
  loaded[spec.name] = true
  for _, dep in ipairs(spec.dependencies or {}) do
    local dep_spec = specs[dep]
    if dep_spec then
      load_plugin(dep_spec, defer)
    else
      vim.notify(('pack.lua: %s depends on unknown plugin %q'):format(spec.name, dep), vim.log.levels.WARN)
    end
  end
  vim.cmd.packadd({ spec.name, bang = defer })
  if spec.config then
    spec.config()
  end
end

---@param queue table<string, PackSpec[]> event name (or "Event pattern") -> specs to load
local function stub_events(queue)
  -- Build the chain of events to replay after loading plugins.
  -- FileType triggers BufReadPost -> BufReadPre so late-loaded plugins see the full chain.
  local function get_event_chain(event, buf, data)
    local chain = {}
    local triggers = { FileType = 'BufReadPost', BufReadPost = 'BufReadPre' }
    while event do
      local groups = {}
      if event ~= 'FileType' then
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = event })) do
          if autocmd.group_name then
            groups[autocmd.group_name] = true
          end
        end
      end
      table.insert(chain, 1, { event = event, buffer = buf, exclude = groups, data = data })
      data = nil
      event = triggers[event]
    end
    return chain
  end

  for event, event_specs in pairs(queue) do
    local event_name, pattern = event:match('^(%S+)%s+(.+)$')
    vim.api.nvim_create_autocmd(event_name or event, {
      pattern = pattern,
      once = true,
      desc = 'Pack lazy ' .. event,
      callback = function(ev)
        local chain = (event_name or event) ~= 'User' and get_event_chain(ev.event, ev.buf, ev.data) or {}
        for _, spec in ipairs(event_specs) do
          load_plugin(spec)
        end
        for _, opts in ipairs(chain) do
          if next(opts.exclude) == nil then
            vim.api.nvim_exec_autocmds(opts.event, {
              buffer = opts.buffer,
              modeline = false,
              data = opts.data,
            })
          else
            local done = {}
            for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = opts.event })) do
              local id = autocmd.event .. ':' .. (autocmd.group or '')
              if autocmd.group and not done[id] and not opts.exclude[autocmd.group_name] then
                done[id] = true
                vim.api.nvim_exec_autocmds(opts.event, {
                  buffer = opts.buffer,
                  group = autocmd.group_name,
                  modeline = false,
                  data = opts.data,
                })
              end
            end
          end
        end
      end,
    })
  end
end

---@param spec PackSpec
---@param load_queue PackSpec[] specs to load eagerly at startup
---@param event_queue table<string, PackSpec[]> event name -> specs to load on that event
local function setup_lazy(spec, load_queue, event_queue)
  if spec.lazy == false then
    if spec.keys then
      for _, k in ipairs(spec.keys) do
        vim.keymap.set(k[1], k[2], k[3], k[4] or {})
      end
    end
    table.insert(load_queue, spec)
    return
  end

  if spec.event then
    for _, event in ipairs(spec.event) do
      event_queue[event] = event_queue[event] or {}
      table.insert(event_queue[event], spec)
    end
  end

  if spec.keys then
    for _, mapping in ipairs(spec.keys) do
      vim.keymap.set(mapping[1], mapping[2], function()
        for _, k in ipairs(spec.keys) do
          if k[3] then
            vim.keymap.set(k[1], k[2], k[3], k[4] or {})
          else
            pcall(vim.keymap.del, k[1], k[2])
          end
        end
        load_plugin(spec)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(mapping[2], true, true, true), 'm', false)
      end, mapping[4] or {})
    end
  end

  if spec.cmd then
    for _, cmd in ipairs(spec.cmd) do
      vim.api.nvim_create_user_command(cmd, function(ev)
        for _, c in ipairs(spec.cmd) do
          pcall(vim.api.nvim_del_user_command, c)
        end
        load_plugin(spec)
        local command = { cmd = cmd, bang = ev.bang, mods = ev.smods, args = ev.fargs }
        if ev.range == 1 then
          command.range = { ev.line1 }
        elseif ev.range == 2 then
          command.range = { ev.line1, ev.line2 }
        elseif ev.count >= 0 then
          command.count = ev.count
        end
        vim.cmd(command)
      end, {
        bang = true,
        nargs = '*',
        range = true,
        complete = function(_, line)
          for _, c in ipairs(spec.cmd) do
            pcall(vim.api.nvim_del_user_command, c)
          end
          load_plugin(spec)
          return vim.fn.getcompletion(line, 'cmdline')
        end,
      })
    end
  end
end

local function setup_commands()
  vim.api.nvim_create_user_command('PackBuild', function(opts)
    if opts.args ~= '' then
      local spec = specs[opts.args]
      if spec and spec.build then
        run_build(spec)
      else
        vim.notify('No build for plugin: ' .. opts.args, vim.log.levels.WARN)
      end
      return
    end
    for _, spec in pairs(specs) do
      if spec.build then
        run_build(spec)
      end
    end
  end, {
    nargs = '?',
    desc = 'Run build for one plugin (by name) or all',
    complete = function()
      local names = {}
      for name, spec in pairs(specs) do
        if spec.build then
          table.insert(names, name)
        end
      end
      return names
    end,
  })
end

function M.setup()
  local pack_specs = {}
  local event_queue, load_queue, build_queue = {}, {}, {}

  local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'
  for name, kind in vim.fs.dir(plugins_dir) do
    if kind == 'file' and name:match('%.lua$') then
      local mod = require('plugins.' .. name:gsub('%.lua$', ''))
      for _, spec in ipairs(mod) do
        spec.name = spec.name or spec[1]:match('[^/]+$'):gsub('%.git$', '')
        specs[spec.name] = spec
        table.insert(pack_specs, to_pack_spec(spec))
        setup_lazy(spec, load_queue, event_queue)
        if spec.init then
          spec.init()
        end
      end
    end
  end

  stub_events(event_queue)

  vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'pack.lua: run build callbacks',
    callback = function(event)
      if event.data.kind ~= 'install' and event.data.kind ~= 'update' then
        return
      end
      local spec = specs[event.data.spec.name]
      if not spec or not spec.build then
        return
      end
      if build_queue then
        table.insert(build_queue, spec)
      else
        run_build(spec)
      end
    end,
  })

  -- Register every spec so vim.pack owns install, `version` pinning, the
  -- lockfile and `:packdel ++all`. The no-op `load` leaves loading to us.
  vim.pack.add(pack_specs, { load = function() end, confirm = false })

  for _, spec in ipairs(build_queue) do
    run_build(spec)
  end
  for _, spec in ipairs(load_queue) do
    load_plugin(spec, true)
  end
  build_queue = nil

  setup_commands()
end

return M
