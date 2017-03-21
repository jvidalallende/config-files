" ~/.vimrc (configuration file for vim only)

" Activate Pathogen (easy install plugins by creating a 
" folder in .vim/bundle. Call it before 'filetype on',
" since they seem to conflict
call pathogen#infect()

" Syntax highlighting
syntax on
filetype on

" Avoiding clipboard sync improves startup times A LOT
" http://stackoverflow.com/questions/14635295/vim-takes-a-very-long-time-to-start-up
set clipboard=exclude:.*

" Open with predefined type
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pu set filetype=plantuml
autocmd BufNewFile,BufReadPost *SCons* set filetype=python


"""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""" Remove trailing whitespaces """""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
:nnoremap <silent> <F3> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""         NERDtree         """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
map <F4> :NERDTreeToggle<CR>
" Fix problem with arrows in some terminals
let NERDTreeDirArrows=0

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""       TagbarToogle       """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" This opens a side window for easy code navigation
" Configuration based on http://amix.dk/blog/post/19329
map <F5> :TagbarToggle<cr>
" Reduce the time required to update the tabs
set updatetime=100

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""          Tabs            """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-k> :tabprev <CR>
map <C-l> :tabnext <CR>
map <C-e> :tabe

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""        Syntastic         """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" C++11 with syntastic
let g:syntastic_cpp_compiler = 'clang++'
let g:clang_library_path = '/usr/lib/llvm-3.6/lib/'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
 
function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         Errors
    else
        lclose
    endif
endfunction:

nnoremap <silent> <F2> :call ToggleErrors() <CR>

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
set laststatus=2        "Always show the status bar
set statusline=%F       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""       Color scheme       """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme file is stored in ~/.vim/colors/solarized.vim
"syntax enable
set background=dark
colorscheme solarized

" Set terminal to use 16 colors instead of just 8
set t_Co=16


"""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""   Other userful stuff    """"""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""
" Show line numbers
set number
" line wrapping
set nowrap
" Display underline below cursor, only in current window
set cursorline
" Vertical line to show 80-characters wide
set colorcolumn=80
" Remove trailing whitespaces
nnoremap <silent> <F3> :%s/\s\+$//<CR>
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

"~/.vimrc ends here
