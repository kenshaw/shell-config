"---------------------------------------------------
set title relativenumber nohlsearch mouse= completeopt-=preview
set tabstop=4 shiftwidth=4 expandtab
set encoding=utf-8 nobomb
set ignorecase smartcase gdefault
set undofile wildignore=*.o,*.obj,*.bak,*.exe,*.swp
set signcolumn=yes

" keep cursor in center of screen
set scrolloff=40 showmode showcmd hidden wildmode=list:longest

syntax on
highlight clear SignColumn
"---------------------------------------------------


"---------------------------------------------------
call plug#begin('~/.nvim/plugged')

"---------------------------------------------------
" deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
"---------------------------------------------------

" status / side bar
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" edit mode plugins
Plug 'tmhedberg/matchit'
Plug 'Raimondi/delimitMate'
Plug 'alvan/vim-closetag'

" other
Plug 'godlygeek/tabular'
Plug 'editorconfig/editorconfig-vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'vim-syntastic/syntastic'

" google codefmt
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" languages
Plug 'bazelbuild/vim-bazel', { 'for': 'bzl' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'corylanou/vim-present', { 'for': 'present' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'exu/pgsql.vim', { 'for': 'sql' }
Plug 'fatih/vim-go', { 'for': 'go' } | Plug 'zchee/deoplete-go', { 'do': ':GoInstallBinaries' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'mattn/anko', { 'for': 'anko', 'dir': '~/src/go/src/github.com/mattn/anko', 'rtp': 'misc/vim' }
Plug 'othree/yajs.vim', { 'for': 'javascript' } | Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' } | Plug 'davinche/godown-vim'
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug '~/src/protobuf/editors', { 'for': 'proto' }

call plug#end()
"---------------------------------------------------


"---------------------------------------------------
" plugin settings
let delimitMate_expand_cr = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:closetag_filenames = '*.html,*.xml'
let g:deoplete#enable_at_startup = 1
let g:flow#qfsize = 0
let g:godown_autorun = 1
let g:godown_port = 7331
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1
let g:rustfmt_autosave = 1
let g:sql_type_default = 'pgsql'
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

" vim-go settings
let g:go_auto_type_info = 1
let g:go_fmt_command = 'goimports'
let g:go_fmt_fail_silently = 1
let g:go_gocode_unimported_packages = 1
let g:go_list_type = "quickfix"

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_rust_checkers = ['rustc']
let g:syntastic_go_checkers = ['gofmt']

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 2
"let g:syntastic_loc_list_height = 3
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "\u2717"
"let g:syntastic_warning_symbol = "\u26A0"
"---------------------------------------------------


"---------------------------------------------------
" glaive + codefmt
call glaive#Install()

" cd ~/src/jtools/ && git clone https://github.com/google/google-java-format.git
" cd google-java-format && mvn clean package --projects core
"let g:java_fmt_jar_path = ''
"let g:java_fmt_options = '--aosp'
Glaive codefmt google_java_executable="java -jar /home/ken/src/jtools/google-java-format/core/target/google-java-format-1.6-SNAPSHOT-all-deps.jar"

augroup autoformat_settings
	autocmd FileType bzl AutoFormatBuffer buildifier
	autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
	autocmd FileType dart AutoFormatBuffer dartfmt
	"autocmd FileType go AutoFormatBuffer gofmt
	autocmd FileType gn AutoFormatBuffer gn
	autocmd FileType html,css,json AutoFormatBuffer js-beautify
	autocmd FileType java AutoFormatBuffer google-java-format
	autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType rust AutoFormatBuffer rustfmt
	" alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END
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
vmap gl :Gblame<CR>

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
autocmd FileType html,xml,ruby,sh,javascript,javascript.jsx,jsx,json,yaml,sql,vim,cmake,proto,typescript,ps1,anko,bzl setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType gitconfig setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
autocmd BufNewFile,BufRead *.qtpl setlocal filetype=go
autocmd BufNewFile,BufRead *.bolt setlocal filetype=typescript
autocmd BufNewFile,BufRead .*config,*.config,config setlocal filetype=gitconfig
autocmd BufNewFile,BufRead *.cql setlocal filetype=cql
autocmd BufNewFile,BufRead *.go.tpl,*.peg setlocal syntax=go
autocmd BufNewFile,BufRead *.gradle setlocal filetype=groovy shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.groovy setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.re setlocal filetype=c
autocmd BufNewFile,BufRead *.thrift setlocal filetype=thrift
autocmd BufNewFile,BufRead *.twig setlocal filetype=html.twig
autocmd BufRead,BufNewFile *.g set filetype=antlr3 shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufRead,BufNewFile *.g4 set filetype=antlr4 shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
"---------------------------------------------------


"---------------------------------------------------
" override settings from vim-sensible
autocmd FileType * set noautoindent nottimeout ttimeoutlen=0
