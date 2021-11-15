vim.cmd [[
  nnoremap <silent> <Leader>t :Vista!!<CR>
  nnoremap <C-p><C-s> :Vista finder<CR>
  let g:vista_ignore_kinds = ['Variable']
]]

vim.g.vista_default_executive = 'nvim_lsp'
