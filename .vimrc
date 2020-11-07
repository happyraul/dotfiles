set relativenumber "Relative line numbers
set autoread "Reload modified files automatically
set number
set expandtab "Use spaces instead of tab
set shiftwidth=4 "Indenting is 4 spaces, not 8
set softtabstop=4 "Number of spaces inserted when inputting tab
set tabstop=4
set colorcolumn=80

let g:netrw_banner = 0 "No header spam in directory mode
let g:netrw_liststyle = 3 "Tree style
let g:elm_format_fail_silently = 0

" Finding files

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>
syntax on

" edit/source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
inoremap jk <esc>

" surround selection in ()
xnoremap <leader>s xi()<esc>P

iabbrev im import
iabbrev tehn then

" trim trailing whitespace
"autocmd FileType elm,py autocmd BufWritePre <buffer> %s/\s\+$//e
augroup stripWhitespace
    autocmd!
"    autocmd BufWritePre *.elm %s/\s\+$//e
    autocmd BufWritePre *.py %s/\s\+$//e
"    autocmd BufWritePre *.ex %s/\s\+$//e
"    autocmd BufWritePre *.exs %s/\s\+$//e
augroup END

"augroup elixirFormat
"    autocmd!
"    autocmd BufWritePost *.ex silent !mix format mix.exs <afile>
"    autocmd BufWritePost *.exs silent !mix format mix.exs <afile>
"augroup END

augroup elmFormat
    autocmd!
    autocmd BufWritePre *.elm call elm#Format()
    autocmd BufWritePost *.elm call elm#util#EchoStored()
augroup END
" autocmd BufWritePost *.elm silent !elm-format --yes <afile>

set list lcs=trail:·,tab:»·

