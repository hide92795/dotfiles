"==================================================
" START NeoBundle Plugin Config
"==================================================
set nocompatible
filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
" Installing Plugins
" from Github
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'taku-o/vim-toggle'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'sjl/gundo.vim'
" from Vim scripts
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'AutoClose'
NeoBundle 'Align'

filetype plugin indent on
"==================================================
" END NeoBundle Plugin Config
"==================================================

"==================================================
" START neocomplete.vim Plugin Config
"==================================================
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
"==================================================
" END"neocomplete.vim Plugin Config
"==================================================

"==================================================
" START Startify Plugin Config
"==================================================
" Launch Startify and move cursor to top.
autocmd VimEnter * if !argc() | Startify | 1 | endif
"==================================================
" END Startify Plugin Config
"==================================================

"==================================================
" START NERDTree Plugin Config
"==================================================
" Run NERDTree when vim launch without args.
autocmd vimenter * if !argc() | NERDTree | endif
" Close Vim when showing NERDTree only.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Show hidden files.
let g:NERDTreeShowHidden =1
" Double-click to open dir, Single-click to open file.
let g:NERDTreeMouseMode =2
" Ctrl+E to open/close NERDTree
nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
"==================================================
" END NERDTree Plugin Config
"==================================================

"==================================================
" START lightline Plugin Config
"==================================================
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
"==================================================
" END lightline Plugin Config
"==================================================

"==================================================
" START tagbar Plugin Config
"==================================================
nmap <F8> :TagbarToggle<CR>
"==================================================
" END tagbar Plugin Config
"==================================================

"==================================================
" START Gundo Plugin Config
"==================================================
nmap <F9> :GundoToggle<CR>
let g:gundo_auto_preview = 0
let g:gundo_right = 1
"==================================================
" END Gundo Plugin Config
"==================================================


"==================================================
" START Editor Config
"==================================================
set backspace =indent,eol,start
set whichwrap =b,s,h,l,<,>,[,]
"==================================================
" END Editor Config
"==================================================

"==================================================
" START Display Config
"==================================================
syntax on
colorscheme molokai
let g:rehash256 =1
set laststatus =2
set number
set title
set showcmd
set ruler
set showmatch
"==================================================
" END Display Config
"==================================================

"==================================================
" START File Config
"==================================================
set encoding =UTF-8
set hidden
set autoread
"==================================================
" END File Config
"==================================================

"==================================================
" START Mouse Config
"==================================================
if has('mouse')
	set mouse=a
	if has('mouse_sgr')
		set ttymouse=sgr
	elseif v:version > 703 || v:version is 703 && has('patch632')
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	endif
endif
"==================================================
" START Mouse Config
"==================================================

"==================================================
" START Other Config
"==================================================
helptags ~/.vim/doc
set helplang =ja,en
set confirm
"==================================================
" END Other Config
"==================================================


