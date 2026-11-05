local cmd = vim.api.nvim_command

cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  cmd("syntax reset")
end

vim.g.colors_name = "oxidefox"

local hi = function(group, opts)
  local gui = opts.gui or "NONE"
  local sp = opts.sp or "NONE"
  local fg = opts.fg or "NONE"
  local bg = opts.bg or "NONE"
  cmd(string.format(
    "highlight %s guifg=%s guibg=%s gui=%s guisp=%s",
    group, fg, bg, gui, sp
  ))
end

local palette = {
  black = "#282828",
  lgray = "#BABABA",
  red = "#EE5396",
  green = "#25be6a",
  blue = "#78A9FF",
  magenta = "#BE95FF",
  cyan = "#45C8F7",
  turq = "#38D9B6",
  white = "#DFDFE0",
  orange = "#FFB14A",
  pink = "#FF7EB6",

  comment = "#6B7280",

  sel0 = "#3A3A3A",
  sel1 = "#525253",
}

local syntax = {
  comment = palette.comment,
  conditional = palette.magenta,
  const = palette.orange,
  field = palette.blue,
  func = palette.blue,
  ident = palette.blue,
  keyword = palette.magenta,
  operator = palette.lgray,
  preproc = palette.pink,
  statement = palette.magenta,
  string = palette.green,
  type = palette.turq,
  variable = palette.white,
}

local diag = {
  error = palette.red,
  warn = palette.orange,
  info = palette.blue,
  hint = palette.magenta,
  ok = palette.green,
}

local diag_bg = {
  error = "#271c21",
  warn = "#212120",
  info = "#1c2127",
  hint = "#271c21",
  ok = "#1c2120",
}

-- GUI
hi("Normal", { bg = "none" })
hi("NormalNC", { bg = "none" })
hi("SignColumn", { bg = "none" })
hi("FoldColumn", { bg = "none" })
hi("EndOfBuffer", { fg = palette.comment, bg = "none" })
hi("Visual", { bg = palette.sel0 })
hi("VisualNOS", { bg = palette.sel0 })

hi("Search", { bg = palette.sel1 })
hi("IncSearch", { bg = palette.sel1 })

hi("Pmenu", { bg = palette.black })
hi("PmenuSel", { bg = palette.sel0, gui = "bold" })

hi("MatchParen", { fg = palette.orange, gui = "bold" })
hi("CursorLineNr", { fg = palette.orange, gui = "bold" })
hi('StatusLine', { fg = '#DDDDDD', bg = '#333333' })
hi('StatusLineNC', { fg = '#AAAAAA', bg = '#111111' })
hi('StatusLineTerm', { fg = '#DDDDDD', bg = '#333333' })
hi('StatusLineTermNC', { fg = '#AAAAAA', bg = '#111111' })

hi("MoreMsg", { fg = palette.blue, gui = 'bold' })
hi("Title", { fg = palette.blue, gui = 'bold' })
hi("Question", { fg = palette.blue, gui = 'bold' })
hi("QuickFixLine", { fg = palette.white })
hi("WarningMsg", { fg = palette.orange, gui = 'bold' })

hi("Directory", { fg = palette.blue })
hi("Special", { fg = palette.blue })
hi("SpecialChar", { fg = palette.blue })
hi("Tag", { fg = palette.blue })
hi("SpecialComment", { fg = palette.blue })
hi("Debug", { fg = palette.blue })

-- syntax
hi("Comment", { fg = syntax.comment })

hi("Constant", { fg = syntax.const })
hi("String", { fg = syntax.string })

hi("Identifier", { fg = syntax.ident })
hi("Function", { fg = syntax.func  })

hi("Statement", { fg = syntax.statement })
hi("Keyword", { fg = syntax.keyword })
hi("Conditional", { fg = syntax.conditional })

hi("Type", { fg = syntax.type })

hi("Number", { fg = syntax.const })
hi("Boolean", { fg = syntax.const })

hi("PreProc", { fg = syntax.preproc })

hi("Operator", { fg = syntax.operator })

hi("SpecialKey", { fg = palette.comment })

hi("Todo", { fg = syntax.comment, gui = "bold,italic" })


-- Diagnostics
hi("DiagnosticError", { fg = diag.error })
hi("DiagnosticError", { fg = diag.error })
hi("DiagnosticWarn", { fg = diag.warn })
hi("DiagnosticInfo", { fg = diag.info })
hi("DiagnosticHint", { fg = diag.hint })
hi("DiagnosticOk", { fg = diag.ok })

hi("DiagnosticVirtualTextError", { fg = diag.error, bg = diag_bg.error })
hi("DiagnosticVirtualTextWarn", { fg = diag.warn,  bg = diag_bg.warn })
hi("DiagnosticVirtualTextInfo", { fg = diag.info,  bg = diag_bg.info })
hi("DiagnosticVirtualTextHint", { fg = diag.hint,  bg = diag_bg.hint })
hi("DiagnosticVirtualTextOk", { fg = diag.ok,    bg = diag_bg.ok })

hi("DiagnosticUnderlineError", { sp = diag.error, gui = "undercurl" })
hi("SpellBad", { sp = diag.error, gui = "undercurl" })
hi("DiagnosticUnderlineWarn", { sp = diag.warn,  gui = "undercurl" })
hi("SpellCap", { sp = diag.warn, gui = "undercurl" })
hi("DiagnosticUnderlineInfo", { sp = diag.info,  gui = "undercurl" })
hi("SpellLocal", { sp = diag.info, gui = "undercurl" })
hi("DiagnosticUnderlineHint", { sp = diag.hint,  gui = "undercurl" })
hi("SpellRare", { sp = diag.hint, gui = "undercurl" })
hi("DiagnosticUnderlineOk", { sp = diag.ok,    gui = "undercurl" })

-- LSP and treesitter
hi('@constructor', {})
hi('@lsp.typemod.variable.defaultLibrary', { fg = palette.red } )
hi('@lsp.typemod.function.defaultLibrary', { fg = palette.red } )
hi('@lsp.typemod.macro.defaultLibrary', { fg = palette.red } )
hi('@variable.builtin', { fg = palette.red } )
hi('@variable.parameter', { fg = palette.cyan } )
hi('@variable.parameter.builtin', { fg = palette.blue } )
hi('@variable.member', { fg = palette.blue } )
hi('@constant.builtin', { fg = palette.red } )
hi('@function.builtin', { fg = palette.red } )
hi('@lsp.type.macro', { fg = palette.red } )
hi('@function.macro', { fg = palette.red } )
hi('@module.builtin', { fg = palette.red } )
hi('@string.special', { fg = palette.blue } )
hi('@string.special.url', { fg = palette.cyan, gui = "italic,underline" } )
hi('@character', { fg = syntax.string } )
hi('@character.special', { fg = palette.cyan } )
hi('@type.builtin', { fg = palette.blue } )
hi('@operator', { fg = syntax.operator })
hi('@keyword.return', { fg = palette.red })
hi('@keyword.import', { fg = palette.pink })
hi('@keyword.operator', { fg = syntax.operator })
hi('@punctuation.delimiter', { fg = syntax.operator })
hi('@punctuation.bracket', { fg = syntax.operator })
hi('@markup.strong', { fg = palette.red, gui = "bold" })
hi('@markup.heading', { fg = palette.blue, gui = "bold" })
hi('@markup.quote', { fg = palette.lgray })
hi('@markup.math', { fg = palette.blue })
hi('@markup.link', { fg = palette.magenta, gui = 'bold' })
hi('@markup.link.label', { fg = palette.blue })
hi('@markup.link.url', { fg = palette.cyan, gui = 'underline,italic' })
hi('@markup.raw', { fg = palette.cyan, gui = 'italic' })
hi('@markup.raw.block', { fg = palette.pink })
hi('@markup.list', { fg = palette.cyan })
hi('@markup.list.checked', { fg = palette.green })
hi('@markup.list.unchecked', { fg = palette.turq })
hi('@diff.plus', { fg = palette.green })
hi('@diff.minus', { fg = palette.red })
hi('@diff.delta', { fg = palette.turq })
hi('@tag', { fg = syntax.keyword })
hi('@tag.builtin', { fg = palette.blue })
hi('@tag.attribute', { fg = palette.blue, gui = 'italic' })
hi('@tag.delimiter', { fg = palette.cyan })
