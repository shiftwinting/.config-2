"nmap <Tab> :Defx<cr>
"" 使用 ,e 查找到当前文件位置
"nnoremap <silent> <Leader>e
			"\ :<C-u>Defx 
			"\ -resume -buffer-name=tab`tabpagenr()` -search=`expand('%:p')`<CR>
"call defx#custom#option('_', {
	"\ 'columns': 'indent:git:icons:filename:type',
    "\ 'winwidth': 35,
    "\ 'split': 'vertical',
    "\ 'direction': 'topleft',
    "\ 'show_ignored_files': 0,
    "\ 'buffer_name': '',
    "\ 'toggle': 1,
    "\ 'resume': 1
    "\ })
"call defx#custom#column('git', {
	"\   'indicators': {
	"\     'Modified'  : '•',
	"\     'Staged'    : '✚',
	"\     'Untracked' : 'ᵁ',
	"\     'Renamed'   : '≫',
	"\     'Unmerged'  : '≠',
	"\     'Ignored'   : 'ⁱ',
	"\     'Deleted'   : '✖',
	"\     'Unknown'   : '⁇'
	"\   }
	"\ })
"function! s:defx_toggle_tree() abort
	""Open current file, or toggle directory expand/collapse
	"if defx#is_directory()
		"return defx#do_action('open_or_close_tree')
	"endif
	"return defx#do_action('multi', ['drop', 'quit'])
"endfunction
"" Exit Vim if defxTree is the only window left.
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:defx') |
			"\ quit | endif
"" 在打开多个tab的情况下，当前tab里只有一个buffer和nerd树，当关闭buffer时，自动关闭当前标签页的nerd树
"autocmd BufEnter * if tabpagenr('$') > 1 && winnr('$') == 1 && exists('b:defx') |
			"\ tabclose | endif
"" Internal functions
"" ---
"function! s:jump_dirty(dir) abort
	"" Jump to the next position with defx-git dirty symbols
	"let l:icons = get(g:, 'defx_git_indicators', {})
	"let l:icons_pattern = join(values(l:icons), '\|')

	"if ! empty(l:icons_pattern)
		"let l:direction = a:dir > 0 ? 'w' : 'bw'
		"return search(printf('\(%s\)', l:icons_pattern), l:direction)
	"endif
"endfunction
"autocmd FileType defx call s:defx_mappings()
"function! s:defx_mappings() abort
	"nnoremap <silent><buffer><expr> o		 <SID>defx_toggle_tree()                    " 打开或者关闭文件夹，文件
	"nnoremap <silent><buffer><expr> O		 defx#do_action('open_tree_recursive')
	"nnoremap <silent><buffer><expr> l        <SID>defx_toggle_tree() 
	"nnoremap <silent><buffer><expr> <CR>     defx#do_action('drop')
	"nnoremap <silent><buffer><expr> q        defx#do_action('quit')
	"nnoremap <silent><buffer><expr><Esc>     defx#do_action('quit')
	"nnoremap <silent><buffer><expr> h    
				"\ defx#is_opened_tree() ? 
				"\ defx#do_action('close_tree', defx#get_candidate().action__path) : 
				"\ defx#do_action('search',  fnamemodify(defx#get_candidate().action__path, ':h'))

	"" File/dir management
	"nnoremap <silent><buffer><expr> dd       defx#do_action('remove_trash')
	"nnoremap <silent><buffer><expr> yy       defx#do_action('copy')
	"nnoremap <silent><buffer><expr> YY       defx#do_action('yank_path')
	"nnoremap <silent><buffer><expr> mm       defx#do_action('move')
	"nnoremap <silent><buffer><expr> pp       defx#do_action('paste')
	"nnoremap <silent><buffer><expr> N        defx#do_action('new_file')				" 新建文件
	"nnoremap <silent><buffer><expr> K		 defx#do_action('new_directory')		" 新建文件夹
	"nnoremap <silent><buffer><expr> M        defx#do_action('new_multiple_files')   " 批量新建文件
	"nnoremap <silent><buffer><expr> R        defx#do_action('rename')

	"nnoremap <silent><buffer><expr> j        line('.') == line('$') ? 'gg' : 'j'	" 最上面跳到底下
	"nnoremap <silent><buffer><expr> k        line('.') == 1 ? 'G' : 'k'				" 最下面跳到顶部
	"nnoremap <silent><buffer><expr> i        defx#do_action('open', 'choose')
	"nnoremap <silent><buffer><expr> E        defx#do_action('open', 'vsplit')
	"nnoremap <silent><buffer><expr> P        defx#do_action('preview')
	"nnoremap <silent><buffer><expr> !        defx#do_action('execute_command')
	"nnoremap <silent><buffer><expr> x        defx#do_action('execute_system')
	"nnoremap <silent><buffer><expr> .        defx#do_action('toggle_ignored_files')
	"nnoremap <silent><buffer><expr> ;        defx#do_action('repeat')
	"nnoremap <silent><buffer><expr> r        defx#do_action('redraw')
	"nnoremap <silent><buffer><expr> pr       defx#do_action('print')
	"nnoremap <silent><buffer><expr> <        defx#do_action('resize',  defx#get_context().winwidth - 10)
	"nnoremap <silent><buffer><expr> >        defx#do_action('resize',  defx#get_context().winwidth + 10)

	"" Change directory
	"nnoremap <silent><buffer><expr> ~        defx#do_action('cd')
	"nnoremap <silent><buffer><expr> u        defx#do_action('cd', ['..'])
	"nnoremap <silent><buffer><expr> cd		 defx#do_action('cd', [defx#get_candidate().action__path])

	"" Jump
	"nnoremap <silent><buffer>  [g :<C-u>call <SID>jump_dirty(-1)<CR>
	"nnoremap <silent><buffer>  ]g :<C-u>call <SID>jump_dirty(1)<CR>

	"" Selection
	"nnoremap <silent><buffer><expr> *		 defx#do_action('toggle_select_all')
	"nnoremap <silent><buffer><expr> m        defx#do_action('clear_select_all')
	"nnoremap <silent><buffer><expr><nowait> <Space>
		"\ defx#do_action('toggle_select') . 'j'

	"nnoremap <silent><buffer><expr> S  defx#do_action('toggle_sort', 'Time')
	"nnoremap <silent><buffer><expr> C
		"\ defx#do_action('toggle_columns', 'indent:mark:filename:type:size:time')
"endfunction
