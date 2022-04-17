"###################################################
"# => Moving around, tabs, windows and buffers
"###################################################

" using command history
" nnoremap : q:i
nnoremap / q/i
nnoremap ? q?i

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" easier moving of code blocks
" " Try to go into visual mode (v), thenselect several lines of code here and
" " then press ``>`` several times.
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation

"#########################
"# => Misc
"#########################

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" ToggleMovement function for keys
" http://ddrscott.github.io/blog/2016/vim-toggle-movement/
" The original carat 0 swap
nnoremap <silent> 0 :call ToggleMovement('^', '0')<CR>
