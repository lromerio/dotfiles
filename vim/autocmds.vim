" Delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" If it is an assembly file use asm
au BufRead,BufNewFile *.asm set filetype=asm
au BufRead,BufNewFile *.nasm set filetype=asm

autocmd BufRead,BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufRead,BufNewFile,BufReadPost *.wiki set filetype=vimwiki

" Quickly change font size un GUI
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" Smarter cursorline
" Disabled when in insert mode
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" If it is an vim file use vim syntax
au BufRead,BufNewFile *.vim set filetype=vim

" Add the proper PEP8 indentation
au BufRead,BufNewFile *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
