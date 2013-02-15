".vimrc -- Vim Main Configuration
" @Author:      The Sighter (sighter@resource-dnb.de)
" @License:     GPL
" @Created:     2013-02-15.
" @Revision:    0.2 

" Section -- Options {{{1
" terminal dependent stuff
" **************************** "

" Pathogen has to be the first thing!
execute pathogen#infect()

" color settings, depending on color status 
" of the used teminal
" TODO make framebuffer mode here
if &t_Co > 2 || has("gui_running")
  	syntax on
  	set hlsearch
    set t_Co=256            		" set 256 color
    let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
	let g:zenburn_high_Contrast=1	" high contrast for zenburn
	colorscheme rdark		  		" define syntax color scheme
endif

" Enable mouse, if compiled in
if has('mouse')
	set mouse=a
endif

set nocompatible				" use vim defaults
set backspace=indent,eol,start	" backspace behaviour
set history=100					" keep 100 lines of command line history
set ruler						" show the cursor position all the time
set showcmd						" display incomplete commands
set incsearch					" do incremental searching
set clipboard+=unnamed			" yank and copy to X clipboard TODO check tut about registers
set foldmethod=marker  			" use the markers to fold
set foldcolumn=4  			    " the width of the column on the left
set number  					" show line-numbers
set showmode             		" show mode at bottom of screen
set laststatus=2 				" show statusline
set statusline=%F%m%r%h%w\ \|\ format:%{&ff}\ \|\ type:%Y\ \|\ pos:%4l,%4v\ \|\ lines:%L\ \|%=%3p%%

set complete+=k         		" enable dictionary completion
set wildmode=longest,list,full  " wildmode sets how completion works after multiple tab strokes
set completeopt=menuone,menu,longest,preview " aquivalent for above
set wildignorecase              " ignore case when completing
set ignorecase                  " smartcase search
set smartcase                   " smartcase search
set autochdir                   " automatacly change dir when opening new buffer

set nowrap						" don't wrap text on end of screen

set tabstop=4       " tab settings
set shiftwidth=4    " used for autoindent
set expandtab       " insert spaces when hitting tab

set spelllang=de    " spelllang

set guifont=Inconsolata\ Medium\ 12 " set font
set guioptions-=T                   "remove toolbar
set guioptions-=r                   "remove right-hand scroll bar
set guioptions-=l                   "remove left-hand scroll bar
set guioptions-=L                   "remove left-hand scroll bar
set guitablabel=[%N]\ %t\ %M

let g:session_autoload = 'no'   " TODO Move this

filetype on 					" enable filetype detection
filetype plugin on				" enable filetype dependent plugins
filetype indent on				" enable filetype dependent indentation



" Section -- autocmd settings {{{1
" ******************************** "

" make an autocmd group
augroup vimrcEx
	" remove all autocmd, so they aren't sourced twice
	autocmd!
	
	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif

    " autocmd for the tagbar
	autocmd BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.py,*.php | exe "TagbarOpen"
	
	" use synax autocompletion, if no omnifunc is set
	autocmd Filetype *
		\ if &omnifunc == "" |
		\ 	setlocal omnifunc=syntaxcomplete#Complete |
		\ endif

    " dirty fix for rdark colorscheme
    "autocmd VimEnter * 
    "    \ if g:colors_name == "rdark" |
    "    \   execute "hi Normal ctermbg=234" |
    "    \ endif

augroup END

" Section -- Functions and Commands {{{1
" ******************************** "

" tab functions for movement
function TabLeft()
   let tab_number = tabpagenr() - 1
   if tab_number == 0
      execute "tabm" tabpagenr('$') - 1
   else
      execute "tabm" tab_number - 1
   endif
endfunction

function TabRight()
   let tab_number = tabpagenr() - 1
   let last_tab_number = tabpagenr('$') - 1
   if tab_number == last_tab_number
      execute "tabm" 0
   else
      execute "tabm" tab_number + 1
   endif
endfunction

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif


" Section -- Extended vim settings and plugin settings{{{1
" ******************************** "

" configure tags - ever source this tag files
set tags+=~/.vim/tags/cpp,~/.vim/tags/libconfig

" tagbar plugin 
let g:tagbar_width = 30
let g:tagbar_left = 1

" ACP options
let g:acp_behaviorKeywordLength = 1

" tskeleton options 
let g:tskelUserName = "The Sighter"
let g:tskelUserEmail = "sighter@resource-dnb.de"
let g:tskelLicense = "GPL"

autocmd BufNewFile *.py TSkeletonSetup python.py
autocmd BufNewFile *.cpp TSkeletonSetup cpp.cpp
autocmd BufNewFile *.cc TSkeletonSetup class_def.cc
autocmd BufNewFile *.h TSkeletonSetup header.h
let g:tskelBitGroup_h = ['h', 'cpp']

" check snipmate TODO

" clang completion
let g:clang_use_library = 1
let g:clang_complete_copen = 1
let g:clang_hl_errors = 1
let g:clang_periodic_quickfix = 1
let g:clang_snippets = 1
let g:clang_conceal_snippets = 1
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1

" Haskell mode
" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" configure browser for haskell_doc.vim
" let g:haddock_browser = "insert path to your web browser"
let g:haddock_browser = "/usr/bin/chromium"

" Section -- key mappings {{{1
" ============================

" no tabs in pastings
set pastetoggle=<f5>

" build ld tags of your own project with Ctrl-F10 TODO make language dependent
map <F10> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" tab
nnoremap <silent> <S-A-Left> :execute TabLeft()<CR>
nnoremap <silent> <S-A-Right> :execute TabRight()<CR>
inoremap <silent> <S-A-Left> <esc>:execute TabLeft()<CR>
inoremap <silent> <S-A-Right> <esc>:execute TabRight()<CR>
nnoremap <silent> <A-Left> :tabprevious<CR>
nnoremap <silent> <A-Right> :tabnext<CR>
inoremap <silent> <A-Left> <esc>:tabprevious<CR>
inoremap <silent> <A-Right> <esc>:tabnext<CR>

" nerdtree
nnoremap <silent> <A-n> :NERDTreeToggle<CR>
inoremap <silent> <A-n> <esc>:NERDTreeToggle<CR>
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
inoremap <silent> <Leader>n <esc>:NERDTreeToggle<CR>

" clang
nnoremap <silent> <F7> :call g:ClangUpdateQuickFix()<CR>
inoremap <silent> <F7> <ESC>:call g:ClangUpdateQuickFix()<CR>

" tskeleton
inoremap <silent> <F6> <ESC>:call tskeleton#ExpandBitUnderCursor('n')<CR>
"nnoremap <F5> :TSkeletonBit<CR>

" tagbar
nnoremap <silent> <F8> :TagbarToggle<CR>
inoremap <silent> <F8> <ESC>:TagbarToggle<CR>
