"let g:floaterm_wintype='split'
"
"let g:floaterm_opener = 'drop'
"
"let g:floaterm_keymap_toggle = '<F1>'
"let g:floaterm_keymap_next   = '<F2>'
"let g:floaterm_keymap_prev   = '<F3>'
"let g:floaterm_keymap_new    = '<F4>'
"let g:floaterm_title=''
"
"" Floaterm
"let g:floaterm_gitcommit='floaterm'
"let g:floaterm_autoinsert=1
"let g:floaterm_width=0.8
"let g:floaterm_height=0.8
"let g:floaterm_wintitle=0
"let g:floaterm_autoclose=1"
"
"map <LocalLeader>g :FloatermNew lazygit<cr> 
"map <LocalLeader>r :FloatermNew ranger<cr> 
"map <LocalLeader>f :FloatermNew fzf --preview 'cat {}'<cr> 
"function! s:list_buffers()
"  redir => list
"  silent ls
"  redir END
"  return split(list, "\n")
"endfunction
"
"function! s:delete_buffers(lines)
"  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
"endfunction
"
"command! BD call fzf#run(fzf#wrap({
"  \ 'source': s:list_buffers(),
"  \ 'sink*': { lines -> s:delete_buffers(lines) },
"  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
"\ }))
"
"noremap <LocalLeader>d :BD<CR>
