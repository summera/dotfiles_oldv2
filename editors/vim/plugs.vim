" ========================================
" Vim plugin configuration
" ========================================

if has("autocmd")
  filetype indent plugin on
endif

call plug#begin('~/.vim/plugged')

runtime plugs/git.plug
runtime plugs/appearance.plug
runtime plugs/textobjects.plug
runtime plugs/search.plug
runtime plugs/project.plug
runtime plugs/vim-improvements.plug
runtime plugs/ruby.plug
runtime plugs/languages.plug

call plug#end()

augroup lazy_load_ultisnips
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips') | autocmd! lazy_load_ultisnips
augroup END
