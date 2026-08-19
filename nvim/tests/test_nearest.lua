-- Checks util.test.nearest_name. Run: nvim -l tests/test_nearest.lua
local test = require('util.test')

local cases = {
  { ft = 'rust', lines = { 'fn helper() {}', 'fn my_test() {', '    let x = 1;', '}' }, line = 3, want = 'my_test' },
  {
    ft = 'python',
    lines = { 'def helper():', '    pass', '', 'def test_thing():', '    x = 1' },
    line = 5,
    want = 'test_thing',
  },
  { ft = 'rust', lines = { 'struct S;' }, line = 1, want = nil },
}

for _, case in ipairs(cases) do
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, case.lines)
  vim.bo[buf].filetype = case.ft
  vim.api.nvim_set_current_buf(buf)
  vim.treesitter.start(buf)
  vim.treesitter.get_parser(buf):parse()
  vim.api.nvim_win_set_cursor(0, { case.line, 0 })
  local got = test.nearest_name()
  assert(got == case.want, ('%s: expected %s, got %s'):format(case.ft, tostring(case.want), tostring(got)))
end

print('ok')
