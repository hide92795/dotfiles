"==================================================
" START MacVim GUI Config
"==================================================
if has('gui_macvim')
	set transparency =3
	colorscheme molokai
	let g:rehash256 = 1
	"set lines =40
	"set columns =140
	set guioptions-=T
endif

if has("gui_running")
	set fuoptions=maxvert,maxhorz
	au GUIEnter * set fullscreen
endif
"==================================================
" END MacVim GUI Config
"==================================================


