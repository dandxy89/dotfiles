-- dantheme: near-monochrome, light and dark (follows 'background'). Hierarchy comes from weight and grey
-- level, not hue; colour is reserved for diagnostics and diffs.

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') == 1 then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'dantheme'

local light = {
  paper = '#ecece7', -- background
  sheet = '#f6f6f3', -- floats, menus
  line = '#e4e4de', -- cursor line, inactive bars
  ink = '#2b2b2b', -- text
  ink2 = '#555553', -- secondary text
  muted = '#666666',
  faint = '#858582', -- comments, line numbers
  rule = '#c1c1c1', -- borders, separators
  sel = '#d6d6d0', -- selection
  hl = '#c9c9c3', -- search

  red = '#b3261e',
  green = '#2e6b3a',
  amber = '#8a6200',
  blue = '#35557f',

  red_bg = '#f2dcd8',
  green_bg = '#dce8da',
  amber_bg = '#efe6cf',
  blue_bg = '#dde3ec',
  difftext = '#e3d3a8',
}

local dark = {
  paper = '#1e1e1d',
  sheet = '#272726',
  line = '#252524',
  ink = '#e4e4df',
  ink2 = '#babab5',
  muted = '#9a9a96',
  faint = '#71716e',
  rule = '#3e3e3c',
  sel = '#373735',
  hl = '#4a4a47',

  red = '#e5786d',
  green = '#8cbf8a',
  amber = '#d9b25c',
  blue = '#8fa8cc',

  red_bg = '#3a2422',
  green_bg = '#223024',
  amber_bg = '#352d1c',
  blue_bg = '#232b38',
  difftext = '#4a3d1f',
}

local p = vim.o.background == 'dark' and dark or light

---@param group string
---@param opts vim.api.keyset.highlight
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- editor
hi('Normal', { fg = p.ink, bg = p.paper })
hi('NormalNC', { link = 'Normal' })
hi('NormalFloat', { fg = p.ink, bg = p.sheet })
hi('FloatBorder', { fg = p.rule, bg = p.sheet })
hi('FloatTitle', { fg = p.ink, bg = p.sheet, bold = true })
hi('SignColumn', {})
hi('FoldColumn', { fg = p.faint })
hi('Folded', { fg = p.muted, bg = p.sheet })
hi('EndOfBuffer', { fg = p.paper })
hi('LineNr', { fg = p.faint })
hi('CursorLineNr', { fg = p.ink, bold = true })
hi('CursorLine', { bg = p.line })
hi('CursorColumn', { link = 'CursorLine' })
hi('ColorColumn', { bg = p.line })
hi('WinSeparator', { fg = p.rule })
hi('VertSplit', { link = 'WinSeparator' })
hi('NonText', { fg = p.rule })
hi('Whitespace', { fg = p.rule })
hi('SpecialKey', { fg = p.faint })
hi('Conceal', { fg = p.faint })

hi('Visual', { bg = p.sel })
hi('VisualNOS', { link = 'Visual' })
hi('Search', { bg = p.hl })
hi('IncSearch', { fg = p.paper, bg = p.ink })
hi('CurSearch', { link = 'IncSearch' })
hi('Substitute', { link = 'IncSearch' })
hi('MatchParen', { bg = p.hl, bold = true })

hi('Pmenu', { fg = p.ink, bg = p.sheet })
hi('PmenuSel', { fg = p.paper, bg = p.ink })
hi('PmenuSbar', { bg = p.sheet })
hi('PmenuThumb', { bg = p.rule })
hi('PmenuKind', { fg = p.muted, bg = p.sheet })
hi('PmenuExtra', { fg = p.faint, bg = p.sheet })

hi('StatusLine', { fg = p.ink, bg = p.sel })
hi('StatusLineNC', { fg = p.faint, bg = p.line })
hi('StatusLineTerm', { link = 'StatusLine' })
hi('StatusLineTermNC', { link = 'StatusLineNC' })
hi('TabLine', { fg = p.muted, bg = p.line })
hi('TabLineSel', { fg = p.ink, bg = p.paper, bold = true })
hi('TabLineFill', { bg = p.line })
hi('WinBar', { fg = p.ink, bold = true })
hi('WinBarNC', { fg = p.faint })

hi('Title', { fg = p.ink, bold = true })
hi('Directory', { fg = p.ink, bold = true })
hi('MoreMsg', { fg = p.ink, bold = true })
hi('ModeMsg', { fg = p.ink, bold = true })
hi('Question', { fg = p.ink, bold = true })
hi('ErrorMsg', { fg = p.red, bold = true })
hi('WarningMsg', { fg = p.amber, bold = true })
hi('QuickFixLine', { bg = p.sel })

hi('DiffAdd', { bg = p.green_bg })
hi('DiffDelete', { fg = p.red, bg = p.red_bg })
hi('DiffChange', { bg = p.amber_bg })
hi('DiffText', { bg = p.difftext, bold = true })
hi('Added', { fg = p.green })
hi('Removed', { fg = p.red })
hi('Changed', { fg = p.amber })

-- syntax: weight and grey, no hue
hi('Comment', { fg = p.faint, italic = true })
hi('Todo', { fg = p.ink, bold = true, italic = true })
hi('Constant', { fg = p.ink2 })
hi('String', { fg = p.muted })
hi('Character', { link = 'String' })
hi('Number', { fg = p.ink2 })
hi('Boolean', { fg = p.ink2, bold = true })
hi('Identifier', { fg = p.ink })
hi('Function', { fg = p.ink, bold = true })
hi('Statement', { fg = p.ink, bold = true })
hi('Keyword', { fg = p.ink, bold = true })
hi('Conditional', { link = 'Keyword' })
hi('Repeat', { link = 'Keyword' })
hi('Operator', { fg = p.muted })
hi('Type', { fg = p.ink, italic = true })
hi('PreProc', { fg = p.ink2, bold = true })
hi('Special', { fg = p.ink2 })
hi('SpecialChar', { fg = p.ink2 })
hi('Delimiter', { fg = p.muted })
hi('Tag', { fg = p.ink, bold = true })
hi('Underlined', { underline = true })
hi('Error', { fg = p.red, bold = true })

-- diagnostics
local diag = { Error = p.red, Warn = p.amber, Info = p.blue, Hint = p.muted, Ok = p.green }
local diag_bg = { Error = p.red_bg, Warn = p.amber_bg, Info = p.blue_bg, Hint = p.sheet, Ok = p.green_bg }
for k, c in pairs(diag) do
  hi('Diagnostic' .. k, { fg = c })
  hi('DiagnosticVirtualText' .. k, { fg = c, bg = diag_bg[k] })
  hi('DiagnosticUnderline' .. k, { sp = c, undercurl = true })
end
hi('SpellBad', { sp = p.red, undercurl = true })
hi('SpellCap', { sp = p.amber, undercurl = true })
hi('SpellLocal', { sp = p.blue, undercurl = true })
hi('SpellRare', { sp = p.muted, undercurl = true })

-- treesitter / LSP
hi('@variable', { fg = p.ink })
hi('@variable.builtin', { fg = p.ink2, italic = true })
hi('@variable.parameter', { fg = p.ink2 })
hi('@variable.member', { fg = p.ink })
hi('@constant.builtin', { fg = p.ink2, bold = true })
hi('@function.builtin', { fg = p.ink, bold = true })
hi('@function.macro', { fg = p.ink2, bold = true })
hi('@module', { fg = p.ink })
hi('@module.builtin', { fg = p.ink2, italic = true })
hi('@constructor', { fg = p.ink, bold = true })
hi('@type.builtin', { fg = p.ink2, italic = true })
hi('@keyword.return', { fg = p.ink, bold = true })
hi('@keyword.import', { fg = p.ink2, bold = true })
hi('@keyword.operator', { fg = p.ink, bold = true })
hi('@punctuation', { fg = p.muted })
hi('@string.escape', { fg = p.ink2, bold = true })
hi('@string.special.url', { fg = p.ink2, underline = true })
hi('@lsp.type.macro', { link = '@function.macro' })
hi('@lsp.typemod.function.defaultLibrary', { link = '@function.builtin' })
hi('@lsp.typemod.variable.defaultLibrary', { link = '@variable.builtin' })

hi('@markup.heading', { fg = p.ink, bold = true })
hi('@markup.strong', { bold = true })
hi('@markup.italic', { italic = true })
hi('@markup.strikethrough', { strikethrough = true })
hi('@markup.quote', { fg = p.muted, italic = true })
hi('@markup.link', { fg = p.ink, underline = true })
hi('@markup.link.label', { fg = p.ink, bold = true })
hi('@markup.link.url', { fg = p.muted, underline = true })
hi('@markup.raw', { fg = p.ink2, bg = p.sheet })
hi('@markup.list', { fg = p.muted })
hi('@markup.list.checked', { fg = p.green })
hi('@diff.plus', { link = 'Added' })
hi('@diff.minus', { link = 'Removed' })
hi('@diff.delta', { link = 'Changed' })
hi('@tag', { fg = p.ink, bold = true })
hi('@tag.attribute', { fg = p.ink2, italic = true })
hi('@tag.delimiter', { fg = p.muted })

vim.g.terminal_color_0 = p.paper
vim.g.terminal_color_1 = p.red
vim.g.terminal_color_2 = p.green
vim.g.terminal_color_3 = p.amber
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = p.ink2
vim.g.terminal_color_6 = p.muted
vim.g.terminal_color_7 = p.rule
vim.g.terminal_color_8 = p.faint
vim.g.terminal_color_9 = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.amber
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.ink2
vim.g.terminal_color_14 = p.muted
vim.g.terminal_color_15 = p.ink
