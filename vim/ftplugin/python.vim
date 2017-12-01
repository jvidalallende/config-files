" Python specific settings

" Indentation
setlocal autoindent
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal smarttab

" Vertical line
setlocal colorcolumn=80

" Run commands
map <F9> :! pylint %
map <F10> :execute pyflakes expand('%t')
