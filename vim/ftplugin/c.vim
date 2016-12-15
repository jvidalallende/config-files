" Configuration file for C/C++

" Indentation
setlocal autoindent
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

" CScope

" Build CScope database (recursive, build-only, with reverse index)
map <F3> :!/usr/bin/cscope -R -b -q <CR>

" Compilation
set makeprg=scons
map <F9> :make <CR>
