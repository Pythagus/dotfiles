call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'nanotech/jellybeans.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'

" Markdown preview plugin
Plug 'skanehira/preview-markdown.vim'
let g:preview_markdown_viewer="/home/dmolina/.vim/bin/mdr_linux_386"

call plug#end()
