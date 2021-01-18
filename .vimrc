
" filetype plugin on
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'powerline/fonts'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdcommenter'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 't9md/vim-choosewin'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'lervag/vimtex'
Plugin 'mattn/emmet-vim'
Plugin 'othree/html5.vim'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-surround'
Plugin 'Chiel92/vim-autoformat'
Plugin 'derekwyatt/vim-scala'
Plugin 'fatih/vim-go'
Plugin 'majutsushi/tagbar'
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'thosakwe/vim-flutter'
Plugin 'kbenzie/vim-spirv'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'tikhomirov/vim-glsl'
Plugin 'dag/vim-fish'
Plugin 'w0rp/ale'
call vundle#end()
filetype plugin indent on

" set <leader>
let mapleader=","

" ================================================
" setting for Plugin

" Airline --------------------
" set status line
set laststatus=2
" enable powerline-fonts
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#branch#enabled=1
" YouCompleteMe -------------------
let g:ycm_global_ycm_extra_conf = '.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_python_binary_path = 'python3'
let g:ycm_complete_in_comments=1
" let g:ycm_collect_identifiers_from_tags_files=1
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
" set max number of completions
let g:ycm_max_num_candidates = 10
" set sign of warning and error
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
" turn off ycm diagnostic
let g:ycm_show_diagnostics_ui = 0
" toggle completion modes inside of insert mode through that key
let g:ycm_semantic_completion_toggle = '<c-f>'
let g:ycm_auto_trigger = 0
let g:ycm_auto_hover = ""
nmap <leader>D <plug>(YCMHover)

" NerdTree -------------------
" open a NERDTree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" F3 to open nerdtree
map <F3> :NERDTreeToggle<CR>
" F4 to find pwd
map <F4> :NERDTreeFind<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" show the dot files
let NERDTreeShowHidden=1
" NERDTree ignore
let NERDTreeIgnore=['\.pyc$','\.swp$']
" NERDTree show BookMarks
let NERDTreeShowBookmarks=1

" vim-nerdtree-tabs
" auto open nerdtree when create new tab
" let g:nerdtree_tabs_open_on_console_startup=1
" On startup, focus NERDTree if opening a directory, focus file if opening a
" file. (When set to 2, always focus file window after startup).
" let g:nerdtree_tabs_smart_startup_focus=1

" NerdCommentor -------------------
let g:NERDSpaceDelims=1

" vim-indent-guides -------------------

" vim-choosewin --------------------
" invoke with '-'
nmap  -  <Plug>(choosewin)

" vim-latex---------------------
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
set shellslash
let g:tex_flavor='latex'
" vim-tagbar
nmap <F12> :TagbarToggle<CR>
" vim-autoformat---------------------
let g:formatdef_my_custom_cpp = '"astyle --mode=c --style=allman --indent-classes --indent=spaces=4 --indent-switches --indent-cases --indent-namespaces --pad-comma --pad-header"'
let g:formatters_cpp = ['my_custom_cpp']
let g:formatdef_autopep8 = "'autopep8  --max-line-length 160 - --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']
nnoremap <Tab> :Autoformat<CR>
" dart-vim-plugin--------------------------------
let dart_style_guide = 2
" vim-flutter----------------------------------

" Some of these key choices were arbitrary;
" it's just an example.
nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>
" ================================================
" vim-gutentags
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" 所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
" =================================================================
"
" google
source /usr/share/vim/google/google.vim
Glug piper plugin[mappings]
Glug g4 prompt=1

" setting for vim basic
set expandtab
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
" exit visual mode without delay
set timeoutlen=1000 ttimeoutlen=0

" ================================================
" custom mapping of original vim

" go to next buffer
nnoremap <leader>bn :bnext<CR>
" go to previous buffer
nnoremap <leader>bb :bprev<CR>
" close current buffer and move to the previous one
nnoremap <leader>bq :bp <BAR> bd #<CR>
" close window along with buffer
nnoremap <leader>wq :bd<CR>
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" store yankring history file there too
let g:yankring_history_dir = '~/.vim/dirs/'
" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
" eliminate search results by <leader>q
nnoremap <leader>q :noh<CR>
" resize window qucikly
nnoremap <Leader>- :resize -10<CR>
nnoremap <Leader>+ :resize +10<CR>
nnoremap <Leader>< :vertical resize -10<CR>
nnoremap <Leader>> :vertical resize +10<CR>
" fold code
set foldmethod=syntax
" clipboard shared with shell
set clipboard=unnamedplus
set clipboard=unnamed
" set backspace attr
set backspace=indent,eol,start
" set tabstop for specefic filetype
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
" remap Ctrl-hjkl to arrow
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-h> <left>
inoremap <c-l> <right>
" don't give ins-completion-menu messages.
set shortmess+=c
set shell=/bin/bash
set encoding=utf-8
