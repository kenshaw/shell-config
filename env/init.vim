"---------------------------------------------------
set title relativenumber nohlsearch mouse= completeopt-=preview
set tabstop=4 shiftwidth=4 expandtab
set encoding=utf-8 nobomb
set ignorecase smartcase gdefault
set undofile wildignore=*.o,*.obj,*.bak,*.exe,*.swp

" keep cursor in center of screen
set scrolloff=40 showmode showcmd hidden wildmode=list:longest

syntax on
highlight clear SignColumn
"---------------------------------------------------


"---------------------------------------------------
" build youcompleteme func
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --tern-completer --omnisharp-completer --gocode-completer
  endif
endfunction
"---------------------------------------------------


"---------------------------------------------------
call plug#begin('~/.nvim/plugged')

" senisble
Plug 'tpope/vim-sensible'

" status / side bar
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" edit mode plugins
Plug 'tmhedberg/matchit'
Plug 'Yggdroot/indentLine'
Plug 'Raimondi/delimitMate'
Plug 'alvan/vim-closetag'

" other
Plug 'godlygeek/tabular'
Plug 'editorconfig/editorconfig-vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" code completion
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'for': ['c', 'cpp', 'csharp', 'rust', 'java'] }
Plug 'Shougo/deoplete.nvim', { 'for': ['scala', 'groovy', 'go'] } | Plug 'ervandew/supertab'
Plug 'ensime/ensime-vim', { 'for': ['scala', 'groovy'] }

" languages
Plug 'cstrahan/vim-capnp', { 'for': 'capnp' }
Plug 'dart-lang/dart-vim-plugin', { 'for': 'dart' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'elubow/cql-vim', { 'for': 'cql' }
Plug 'evidens/vim-twig', { 'for': 'twig' }
Plug 'exu/pgsql.vim', { 'for': 'sql' }
Plug 'fatih/vim-go', { 'for': 'go' } | Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go' }
Plug 'jdonaldson/vaxe', { 'for': 'haxe' }
Plug 'marijnh/tern_for_vim', { 'for': 'javascript' }
Plug 'mxw/vim-xhp', { 'for': 'xhp' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } | Plug 'mxw/vim-jsx', { 'for': 'javascript' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' } |  Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' } | Plug 'm2mdas/phpcomplete-extended-symfony', { 'for': 'php' } | Plug 'm2mdas/phpcomplete-extended-laravel', { 'for': 'php' }
Plug 'solarnz/thrift.vim', { 'for': 'thrift' }
Plug '~/src/protobuf/editors', { 'for': 'proto' }
Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'corylanou/vim-present', { 'for': 'present' }

"Plug 'othree/yajs.vim', { 'for': 'javascript' }

call plug#end()
"---------------------------------------------------


"---------------------------------------------------
" plugin settings
let delimitMate_expand_cr = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:closetag_filenames = '*.html,*.xml'
let g:deoplete#enable_at_startup = 1
let g:gitgutter_sign_column_always = 1
let g:go_auto_type_info = 1
let g:go_fmt_command = 'goimports'
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_term = 111
let g:indentLine_faster = 1
let g:jsx_ext_required = 0
let g:phpcomplete_index_composer_command = '/usr/local/bin/composer'
let g:sql_type_default = 'pgsql'
let g:SuperTabDefaultCompletionType = '<c-n>'

let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
"---------------------------------------------------


"---------------------------------------------------
" always jump to last cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif
"---------------------------------------------------


"---------------------------------------------------
" custom key mappings (dvorak: aoeui dhtns)
" use tabs as well as %s for matching brackets
nnoremap <tab> %
vnoremap <tab> %

" remap ; to : to save on hitting shift
nnoremap ; :

" disable arrow keys
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

" swap ` and q
nnoremap ` q
nnoremap q `

" restore cursor movement
" put <down><up><right><left> on htns (--> hjkl)
nnoremap d h
vnoremap d h
nnoremap h j
vnoremap h j
nnoremap t k
vnoremap t k
nnoremap n l
vnoremap n l

" map s to nothing since i hit it accidentally too often
" map S to join lines
nnoremap s <Nop>
vnoremap s <Nop>
nnoremap S J
vnoremap S <Nop>

" put s on l key
nnoremap l s
vnoremap l s
nnoremap l s
vnoremap l s

" make HT do half page up/down
nnoremap H <C-D>
vnoremap H <C-D>
nnoremap T <C-U>
vnoremap T <C-U>

" since n has been taken over, put it on 'm'
nnoremap m n
vnoremap m n
nnoremap M N
vnoremap M N

" since dD has been taken over, use eE
" p>
nnoremap e d
vnoremap e d
nnoremap ee dd
vnoremap ee dd
nnoremap E C
vnoremap E C
nnoremap EE DD
vnoremap EE DD

" since eE has been taken over, use k
nnoremap k e
vnoremap k e
nnoremap K E
vnoremap K E
nnoremap j <Nop>
vnoremap j <Nop>
nnoremap J <Nop>
vnoremap J <Nop>

" git blame
vmap gl :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>"'")"')

" tabularize maps
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" vim-go leader settings
au FileType go nmap <Leader>r <Plug>(go-rename)
au FileType go nmap <Leader>gd <Plug>(go-def-split)
au FileType go nmap <Leader>gv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gt <Plug>(go-def-tab)
au FileType go nmap <Leader>gs <Plug>(go-doc)

"---------------------------------------------------


"---------------------------------------------------
" strip trailing whitespace
autocmd FileType cmake,c,cs,cpp,gradle,groovy,java,cql,sql,vcl,ice,php,javascript,css,html,perl,ruby,sh,python,gitcommit,gitconfig,git,xml,yml,yaml,markdown autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
"---------------------------------------------------


"---------------------------------------------------
" override file settings
autocmd FileType html,xml,ruby,sh,javascript,json,yaml,sql,vim setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType gitconfig setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
autocmd BufNewFile,BufRead *.groovy setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.twig setlocal filetype=html.twig
autocmd BufNewFile,BufRead *.cql setlocal filetype=cql
autocmd BufNewFile,BufRead *.thrift setlocal filetype=thrift
autocmd BufNewFile,BufRead *.gradle setlocal filetype=groovy shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.re setlocal filetype=c
autocmd BufNewFile,BufRead .*config,*.config,config setlocal filetype=gitconfig
autocmd BufNewFile,BufRead *.go.tpl,*.peg setlocal syntax=go
autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
"---------------------------------------------------


"---------------------------------------------------
" override settings from vim-sensible
autocmd FileType * set noautoindent nottimeout ttimeoutlen=0