"可以在服务启动的时候，自动安装多个扩展插件
let g:coc_global_extensions = [
	\ 'coc-phpls',
	\ 'coc-json',
	\ 'coc-css',
	\ 'coc-html',
	\ 'coc-xml',
	"\ 'coc-pairs',
	\ 'coc-tsserver',
	\ 'coc-yank',
	\ 'coc-snippets' ]

inoremap <silent><expr> <TAB>
	"\ pumvisible() ? coc#_select_confirm() :
	\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

let g:coc_snippet_next = '<tab>'

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" coc-snippets
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-e> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<c-n>'
imap <C-e> <Plug>(coc-snippets-expand-jump)

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
