set ts=4
set sts=4
set sw=4

set keywordprg="help"
compiler php
map <C-L>  :make %<CR>
"map <C-R>  :!php -q %<CR>

set dictionary-=~/.vim/php_function_list.txt dictionary+=~/.vim/php_function_list.txt
" Use the dictionary completion
set complete-=k complete+=k

" syntax options
let php_sql_query = 1
let php_htmlInStrings = 1
let php_parent_error_close = 1
let php_parent_error_open = 1
"let php_folding = 1

" php_abb options
let g:phpNewlineBeforeBrace = 1
let g:phpLeader = "php"
