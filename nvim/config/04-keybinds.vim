"--------------------------自定义快捷键---------------------

" 代码折叠自定义快捷键 <leader>zz
let g:FoldMethod = 0
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

map <leader>zz :call ToggleFold()<cr>

" ===============================================
" === 标签管理===================================
" ===============================================

" buffer
map <C-n> :bnext<cr>
map <C-p> :bprev<cr>
map <leader>1 :bfirst<cr>
map <leader>2 :b2<cr>
map <leader>3 :b3<cr>
map <leader>4 :b4<cr>
map <leader>5 :b5<cr>
map <leader>6 :b6<cr>
map <leader>7 :b7<cr>
map <leader>8 :b8<cr>
map <leader>9 :b9<cr>
map <leader>0 :blast<cr>
map <leader>d :bd<cr>
map <C-o>     :b#<CR>

" Toggles between the active and last active tab "
" Switch to last-active tab
"if !exists('g:Lasttab')
    "let g:Lasttab = 1
    "let g:Lasttab_backup = 1
"endif
"autocmd! TabLeave * let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()
"autocmd! TabClosed * let g:Lasttab = g:Lasttab_backup
"nnoremap <silent> <c-o> :exe "tabn " . g:Lasttab<cr>

" 新建tab  Ctrl+t
"nnoremap <C-t>     :tabnew<CR>
"inoremap <C-t>     <Esc>:tabnew<CR>


" ===============================================
" === 窗口管理===================================
" ===============================================

"Treat long lines as break lines (useful when moving around in them)
""se swap之后，同物理行上线直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j"

" Ctrl+j k h l窗口直接跳转
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" 绑定插入模式下的方向键
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" ===============================================
" === 快捷键 ===================================
" ===============================================

"nnoremap cc dd
"nnoremap x "_x
"nnoremap X "_X
"nnoremap d "_d
"nnoremap dd "_dd
"nnoremap D "_D
"vnoremap d "_d
"vnoremap dd "_dd
xnoremap p "_dP

" 调整缩进后自动选中，方便再次操作
"vmap <tab> >gv
"vmap <s-tab> <gv
vnoremap < <gv
vnoremap > >gv

" map Y y$

" Go to home and end using capitalized directions
" noremap H ^
" noremap L $

" Shift+HJKL快速移动
nnoremap K <Esc>5<up>
nnoremap J <Esc>5<down>

" 滚动Speed up scrolling of the viewport slightly
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" Map ; to : and save a million keystrokes 用于快速进入命令行
"nnoremap ; :

" 交换 ' `, 使得可以快速使用'跳到marked位置
nnoremap ' `
nnoremap ` '

" 选中并高亮最后一次插入的内容
"nnoremap gv `[v`]

" Quickly save the current file
nnoremap <leader>w :w<CR>

" Quickly close the current window
nnoremap <leader>q :q<CR>

" 复制选中区到系统剪切板中
"vnoremap <leader>y "+y

" select block
"nnoremap <leader>v V`}

" 去掉搜索高亮
noremap <silent><Leader>/ :nohls<CR>

" select all
map <Leader>sa ggVG

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" 命令行模式增强
cnoremap <C-a> <Home>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-b> <S-Left>
cnoremap <C-e> <S-Right>

noremap <up> :res +5<CR>
noremap <down> :res -5<CR>
noremap <right> :vertical res -10<CR>
noremap <left> :vertical res +10<CR>

" Disable the default s key
noremap s <Nop>

" w!! to sudo & write a file
"cmap w!! w !sudo tee >/dev/null %

" Compile function
noremap <Leader>p :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		set splitbelow
		:sp
		:res -5
		term javac % && time java %<
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc
