"----[ general settings ]---------------------------
set title relativenumber nohlsearch mouse= completeopt-=preview
set tabstop=4 shiftwidth=4 expandtab
set encoding=utf-8 nobomb nofoldenable
set ignorecase smartcase gdefault
set undofile wildignore=*.o,*.obj,*.bak,*.exe,*.swp
set signcolumn=yes

" keep cursor in center of screen
set scrolloff=40 showmode showcmd hidden wildmode=list:longest

syntax on
highlight clear SignColumn
"---------------------------------------------------


"----[ plugins ]------------------------------------
call plug#begin('~/.nvim/plugged')

"----[ completion ]---------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"----[ status / side bar ]--------------------------
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"----[ general plugins ]----------------------------
Plug 'ervandew/supertab'      " cycle completion with tab
Plug 'tmhedberg/matchit'      " match brackets with %
Plug 'Raimondi/delimitMate'   " autoclose delimiters on open (quotes/brackets)
Plug 'alvan/vim-closetag'     " auto close html tags
Plug 'tpope/vim-abolish'      " smarter substitution
Plug 'godlygeek/tabular'      " tab alignment
Plug 'joshdick/onedark.vim'   " color theme

"----[ language support ]---------------------------
Plug 'sheerun/vim-polyglot'
Plug 'bazelbuild/vim-bazel', { 'for': 'bzl' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'corylanou/vim-present', { 'for': 'present' }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'jdonaldson/vaxe', { 'for': 'haxe' }
Plug 'mattn/anko', { 'for': 'anko', 'dir': '~/src/go/src/github.com/mattn/anko', 'rtp': 'misc/vim' }

call plug#end()
"---------------------------------------------------


"----[ misc ]---------------------------------------
let delimitMate_expand_cr = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:closetag_filenames = '*.html,*.xml'
let g:flow#qfsize = 0
let g:godown_autorun = 1
let g:godown_port = 7331
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1
let g:rustfmt_autosave = 1
let g:sql_type_default = 'pgsql'
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:vaxe_enable_airline_defaults = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

"----[ vim-go ]-------------------------------------
let g:go_auto_type_info = 1
let g:go_fmt_command = 'gofumports'
let g:go_fmt_fail_silently = 1
let g:go_gocode_autobuild = 1
let g:go_gocode_propose_source = 1
let g:go_gocode_unimported_packages = 1
let g:go_highlight_diagnostic_errors = 0
let g:go_highlight_diagnostic_warnings = 0
let g:go_list_type = 'quickfix'
let g:go_updatetime = 350


"----[ colors ]-------------------------------------
let g:onedark_terminal_italics = 1
colorscheme onedark
highlight Normal guibg=none ctermbg=none
highlight SignColumn guibg=none ctermbg=none
highlight LineNr guibg=none ctermbg=none
"highlight GitGutterAdd    guifg=#009900 guibg=none ctermbg=none
"highlight GitGutterChange guifg=#bbbb00 guibg=none ctermbg=none
"highlight GitGutterDelete guifg=#ff2222 guibg=none ctermbg=none
"---------------------------------------------------


"----[ always jump to last cursor position ]--------
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif
"---------------------------------------------------


"----[ custom key maps ]----------------------------
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

" git blame
vmap gl :Gblame<CR>

" tabularize maps
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" dvorak key maps: aoeui dhtns
"
" restore cursor movement (dvorak)
" remap dhtn (<left><down><up><right>) --> hjkl
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

" remap l --> s
nnoremap l s
vnoremap l s
nnoremap l s
vnoremap l s

" map HT do half page up/down
nnoremap H <C-D>
vnoremap H <C-D>
nnoremap T <C-U>
vnoremap T <C-U>

" since n has been taken over,
" map use mM --> nN
nnoremap m n
vnoremap m n
nnoremap M N
vnoremap M N

" since dD has been taken over,
" map e,ee,EE -> d,dd,DD
nnoremap e d
vnoremap e d
nnoremap ee dd
vnoremap ee dd
nnoremap EE DD
vnoremap EE DD

" instead of mapping E -> D,
" map E --> C instead
nnoremap E C
vnoremap E C

" since eE has been taken over,
" map kK --> eE
nnoremap k e
vnoremap k e
nnoremap K E
vnoremap K E

" unmap jJ (dvorak)
nnoremap j <Nop>
vnoremap j <Nop>
nnoremap J <Nop>
vnoremap J <Nop>

" map meta-d/n to move left/right in buffers
nnoremap <M-d> :bprev<CR>
nnoremap <M-n> :bnext<CR>
"---------------------------------------------------


"----[ language ]-----------------------------------
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gz <Plug>(coc-references)
nmap <silent> gf <Plug>(coc-format-selected)
xmap <silent> gf <Plug>(coc-format-selected)
"---------------------------------------------------


"----[ strip trailing whitespace ]------------------
autocmd FileType cmake,c,cs,cpp,gradle,groovy,java,cql,sql,vcl,ice,php,javascript,css,html,perl,ruby,sh,python,gitcommit,gitconfig,git,haxe,xml,yml,yaml,markdown autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
"---------------------------------------------------

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"----[ override file settings ]---------------------
autocmd BufNewFile,BufRead .*config,*.config,config setlocal filetype=gitconfig
autocmd BufNewFile,BufRead *.bolt setlocal filetype=typescript
autocmd BufNewFile,BufRead *.cql setlocal filetype=cql
autocmd BufNewFile,BufRead *.gradle,*.groovy setlocal filetype=groovy shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.osgjs,*.osgjs.gz setlocal filetype=json
autocmd BufNewFile,BufRead *.gunk setlocal filetype=gunk syntax=go
autocmd BufNewFile,BufRead *.go.tpl,*.peg,*.qtpl setlocal filetype=go
autocmd FileType gitconfig setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
autocmd FileType html,xml,ruby,sh,javascript,javascript.jsx,jsx,json,yaml,sql,vim,cmake,proto,typescript,ps1,anko,bzl,text setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
"---------------------------------------------------


"----[ override settings if set by some plugin ]----
autocmd FileType * set noautoindent nottimeout ttimeoutlen=0
