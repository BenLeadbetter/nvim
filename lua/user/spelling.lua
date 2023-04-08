-- underline spelling errors
vim.cmd([[
  hi clear SpellBad
  hi SpellBad cterm=underline
  " Set style for gVim
  hi SpellBad gui=undercurl guisp=red
]])
