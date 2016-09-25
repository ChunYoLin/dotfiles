
filetype plugin on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'powerline/fonts'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdcommenter'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 't9md/vim-choosewin'
Plugin 'jistr/vim-nerdtree-tabs'
call vundle#end()
filetype plugin indent on

" ================================================
" setting for Plugin

" Airline --------------------
" set status line
set laststatus=2
" enable powerline-fonts
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" YouCompleteMe -------------------
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_python_binary_path = 'python'
let g:ycm_complete_in_comments=1
"let g:ycm_collect_identifiers_from_tags_files=1
" complete from word 0
let g:ycm_min_num_of_chars_for_completion=1  
" no pop up window
set completeopt-=preview
" no buffer
let g:ycm_cache_omnifunc=0  
" syntax completion
let g:ycm_seed_identifiers_with_syntax=1
" Ctrl-space to Ctrl-a
let g:ycm_key_invoke_completion = '<C-a>'
" "+g to the definition of cursor word
nmap ,g :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>  
" show warning and error
let g:ycm_max_diagnostics_to_display = 30
" set sign of warning and error
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'

" NerdTree -------------------
" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" F3 to open nerdtree
map <F3> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" show the dot files
let NERDTreeShowHidden=1
" NERDTree ignore
let NERDTreeIgnore=['\.pyc$','\.swp$']

" vim-nerdtree-tabs
" auto open nerdtree when create new tab
let g:nerdtree_tabs_open_on_console_startup=1
" On startup, focus NERDTree if opening a directory, focus file if opening a
" file. (When set to 2, always focus file window after startup).
let g:nerdtree_tabs_smart_startup_focus=1

" NerdCommentor -------------------
let g:NERDSpaceDelims=1

" vim-indent-guides -------------------

" vim-choosewin --------------------
" invoke with '-'
nmap  -  <Plug>(choosewin)

" ================================================
" setting for vim basic

set tabstop=4
set shiftwidth=4
" let vim command can show by tab 
set wildmode=longest,list
set wildmenu
" 256 color for vim
set t_Co=256
" colorscheme 
syntax enable
colorscheme molokai 
" show line number
set number
" realtime search
set incsearch
" don't care for word case while searching 
set ignorecase
" highlight searching result
set hlsearch
" set <leader>
let mapleader=","
