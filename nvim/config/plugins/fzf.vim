map <Leader>f :Files<CR>
map <leader>h :History<CR>
map <leader>b :Buffers<CR>
map <leader>l :Lines<CR>
" command! -bang -nargs=* Rg call fzf#vim#ag(<q-args>, '--color-path "1;39" --color-line "1;30" --color-match "1;31" --color-line-number "1;31"', 
"   \					<bang>0 ? fzf#vim#with_preview('up:60%')
"   \                         : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
command! -bang -nargs=* Sg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <silent> <Leader>s :Sg<CR>
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '20split enew' }
let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
