" ~/.vimrc (configuration file for vim only)

" Activate Pathogen. Do it before 'filetype on', since they seem to conflict
call pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""       Global stuff       """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""

" UTF-8 encoding is almost universal
set encoding=utf-8
" Set terminal to use 256 colors (change to 16 if this gives trouble)
set t_Co=256

" Syntax highlighting
syntax on
filetype on

" Show line numbers
set number
" line wrapping
set nowrap
" Display underline below cursor, only in current window
set cursorline
" Vertical line to show 80-characters wide
set colorcolumn=80
" Enable backspace to work as in most programs (right after insert)
set backspace=indent,eol,start

" Use system clipboard
:set clipboard=unnamed

" Centralized swapfiles
set directory^=$HOME/.vim/swapfiles//
set undodir=~/.vim/undodir
set undofile

" Filetype associations outside defaults
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pu set filetype=plantuml
autocmd BufNewFile,BufReadPost *.plantuml set filetype=plantuml
autocmd BufNewFile,BufReadPost *SCons* set filetype=python

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""          Tabs            """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-k> :tabprev <CR>
map <C-l> :tabnext <CR>
map <C-e> :tabe
" Reduce the time required to update the tabs
set updatetime=100

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""   Search configuration   """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Set up incremental search (as you type), and highlight searches
set incsearch
set hlsearch

" Smartcase is useful in searches. Note that it only works
" when ignorecase is also enabled
" Use example:
" /copyright      " Case insensitive
" /Copyright      " Case sensitive
" /copyright\C    " Case sensitive
" /Copyright\c    " Case insensitive
set ignorecase
set smartcase

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""        Indentation       """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Autoindent does not interfere with file-based indentation
" It just uses the same indentation as the one in the previous line
set autoindent
" These settings avoid the use of hard tabs, and make the
" <TAB> key introduce a four spaces instead
set expandtab
set shiftwidth=4
set softtabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""        Status Bar        """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2                                "Always show the status bar
set statusline=%F\                              "tail of the filename + whitespace
set statusline+=%{FugitiveStatusline()}         "git branch
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]                         "file format
set statusline+=%h                              "help file flag
set statusline+=%m                              "modified flag
set statusline+=%r                              "read only flag
set statusline+=%y                              "filetype
set statusline+=%=                              "left/right separator
set statusline+=%c,                             "cursor column
set statusline+=%l/%L                           "cursor line/total lines
set statusline+=\ %P                            "percent through file

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""       Color scheme       """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme file is stored in ~/.vim/colors/solarized.vim
syntax enable
"let g:solarized_termcolors=256
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized
set background=dark

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""      F-Key Mappings      """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""

" F3 to remove trailing whitespaces
:nnoremap <silent> <F3> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" F4 to replace tabs by whitespaces
:map <silent> <F4> :%s/\t/  /g <CR> :retab<CR> :nohl <CR>

" F7 to change the colorscheme (light/dark, see Solarized config)
call togglebg#map("<F7>")


"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""   Other userful stuff    """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Remap navigation keys, so that we move by 'Display Lines'
" rather than 'real lines'. Useful for wrapped lines.
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Uncomment the following to have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
