filetype plugin on

set relativenumber "Relative line numbers
set autoread "Reload modified files automatically
set number
set expandtab "Use spaces instead of tab
set shiftwidth=4 "Indenting is 4 spaces, not 8
set softtabstop=4 "Number of spaces inserted when inputting tab
set tabstop=4
set colorcolumn=88,100
set scrolloff=5 "Start scrolling when cursor is 5 lines from top/bottom
set sidescrolloff=5
set splitright
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

let g:netrw_banner = 0 "No header spam in directory mode
let g:netrw_liststyle = 3 "Tree style
let g:elm_format_fail_silently = 0

" Finding files

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Ignore pyc files when searching
set wildignore=*.pyc

" Refresh tags on save
"autocmd BufWritePost *.py silent! !ctags -R --python-kinds=-i --languages=python 2&gt; /dev/null &amp;
autocmd BufWritePost *.py silent! !ctags -R --languages=python 2> /dev/null &

nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>
syntax on

" edit/source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
"inoremap jk <esc>

" surround selection in ()
xnoremap <leader>s xi()<esc>P

" insert trailing something
imap ,, <Esc>A,<Esc>

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
    "autocmd!
    "autocmd BufWritePre *.ex silent !mix format mix.exs <afile>
    "autocmd BufWritePre *.exs silent !mix format mix.exs <afile>
"augroup END

augroup elmFormat
    autocmd!
    autocmd BufWritePre *.elm call elm#Format()
    autocmd BufWritePost *.elm call elm#util#EchoStored()
augroup END
" autocmd BufWritePost *.elm silent !elm-format --yes <afile>

set list lcs=trail:·,tab:»·

" whitespace settings
autocmd FileType c setlocal autoindent noexpandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType elixir setlocal autoindent shiftwidth=2 tabstop=2 softtabstop=2
"autocmd FileType terraform setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Format python files with black on save
autocmd BufWritePre *.py execute ':Black'

" Run pylint
"set makeprg=pylint\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p
"set errorformat=%f:%l:\ %m
"autocmd BufWritePost *.py make

" Format terraform files on save
let g:terraform_fmt_on_save=1

" almost black
let g:alduin_Shout_Dragon_Aspect = 1
" black
"let g:alduin_Shout_Become_Ethereal = 1
colorscheme alduin
"set background=dark

command! -range=% Isort :<line1>,<line2>! isort -

function! RunCurrentPythonTest()
python3 << EOF

import re
import vim  # https://vimhelp.org/if_pyth.txt.html

cursor = vim.current.window.cursor
test_filename = vim.eval("expand('%p')")

test_name = None
class_name = None
for line_no in range(cursor[0]-1, -1, -1):
    line = vim.current.buffer[line_no]
    if not test_name and line.lstrip().startswith('def test'):
        test_name = re.findall('def (\w+)\(', line)[0]
    if not class_name and line.startswith('class'):
        class_name = re.findall('class (\w+)\(', line)[0]
        break

cmd = f'!pytest {test_filename}'
if class_name:
    cmd += f'::{class_name}'
if test_name:
    cmd += f'::{test_name}'
vim.command(cmd)

EOF
endfunction
