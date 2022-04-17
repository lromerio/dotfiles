let s:editor_root=expand("~/.vim")

if empty(glob(s:editor_root . '/autoload/plug.vim'))
    autocmd VimEnter * echom "Downloading and installing vim-plug..."
    silent execute "!curl -fLo " . s:editor_root . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall
endif

call plug#begin(s:editor_root . '/plugged')

" Status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/promptline.vim'

" cs([ --> from (asd) to [asd]
Plug 'tpope/vim-surround'

" gc{motion} add/remove comment
Plug 'tomtom/tcomment_vim'

" Automatically insert close delimiter
Plug 'Raimondi/delimitMate'

" Automatic complete with dropdown
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" python
Plug 'deoplete-plugins/deoplete-jedi'
" clang
Plug 'Shougo/deoplete-clangx'
"go
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
" javascript
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

" Syntax plugins & themes
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'ekalinin/Dockerfile.vim' , { 'for': ['docker', 'Dockerfile'] }

call plug#end()

" Needed for ternjs
call deoplete#custom#option('num_processes', 4)

exec "source " . s:editor_root . "/config.vim"
exec "source " . s:editor_root . "/mappings.vim"
exec "source " . s:editor_root . "/autocmds.vim"

