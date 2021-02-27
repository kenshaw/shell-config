"----[ general settings ]---------------------------
set
  \ title relativenumber nohlsearch mouse= updatetime=400
  \ tabstop=4 shiftwidth=4 expandtab encoding=utf-8 nobomb nofoldenable
  \ ignorecase smartcase gdefault undofile signcolumn=yes
  \ scrolloff=40 showmode showcmd hidden wildmode=list:longest " keep cursor in center of screen
  \ wildignore=*.o,*.obj,*.bak,*.exe,*.swp
syntax on
"----[ plugins ]------------------------------------
call plug#begin('~/.nvim/plugged')
"----[ general ]------------------------------------
Plug 'airblade/vim-gitgutter'                       " git status in side bar
Plug 'alvan/vim-closetag'                           " auto close html tags
Plug 'davinche/godown-vim'                          " markdown preview
Plug 'ervandew/supertab'                            " cycle completion with tab
Plug 'godlygeek/tabular'                            " tab alignment
Plug 'joshdick/onedark.vim'                         " color theme
Plug 'neoclide/coc.nvim', {'branch': 'release'}     " completion (language server)
Plug 'Raimondi/delimitMate'                         " autoclose delimiters on open (quotes/brackets)
Plug 'ryanoasis/vim-devicons'                       " fancy icons
Plug 'tmhedberg/matchit'                            " match brackets with %
Plug 'tpope/vim-abolish'                            " smarter substitution
Plug 'tpope/vim-fugitive'                           " git commands
Plug 'vim-airline/vim-airline'                      " fancy status bar
"----[ language syntax/support ]--------------------
Plug 'sheerun/vim-polyglot'
Plug 'bazelbuild/vim-bazel', {'for': 'bzl'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'corylanou/vim-present', {'for': 'present'}
Plug 'jdonaldson/vaxe', {'for': 'haxe'}
Plug 'mattn/anko', {'for': 'anko', 'dir': '~/src/go/src/github.com/mattn/anko', 'rtp': 'misc/vim'}
call plug#end()
"----[ plugin config ]------------------------------
let delimitMate_expand_cr = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:closetag_filenames = '*.html,*.xml'
let g:godown_autorun = 1
let g:godown_port = 7331
let g:sql_type_default = 'pgsql'
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:vaxe_enable_airline_defaults = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
"----[ devicons ]-----------------------------------
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {'go': ''}
"----[ colors ]-------------------------------------
let g:onedark_terminal_italics = 1
colorscheme onedark
highlight clear SignColumn
highlight Normal guibg=none ctermbg=none
highlight LineNr guibg=none ctermbg=none
"----[ language server config ]---------------------
let g:coc_global_extensions = ['coc-clangd', 'coc-emoji', 'coc-go', 'coc-haxe', 'coc-json', 'coc-markdownlint', 'coc-rls']
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! s:doHover()
  if coc#rpc#ready()
    let diagnostics = CocAction('diagnosticList')
    if empty(diagnostics)
      call CocActionAsync('doHover')
      return
    endif
    let file = expand('%:p')
    let lnum = line('.')
    let cnum = col('.')
    for v in diagnostics
      if v['file'] != file
        \ || lnum != v['lnum']
        \ || cnum < v['location']['range']['start']['character']
        \ || cnum > v['location']['range']['end']['character']
        call CocActionAsync('doHover')
        return
      endif
    endfor
  endif
endfunction
autocmd CursorHold
  \ *.go,*.java,*.js,*.json,*.py,*.rs
  \ silent call s:doHover()
"----[ custom key maps ]----------------------------
" disable arrows
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
" map tab --> % -- bracket matching
nnoremap <tab> %
vnoremap <tab> %
" map ; --> : -- save hitting shift
nnoremap ; :
" map `q --> q` -- swap
nnoremap ` q
nnoremap q `
" dvorak key mapping: aoeui dhtns
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
" map s to nothing -- gets hit accidentally too often
nnoremap s <Nop>
vnoremap s <Nop>
" map S --> J -- join lines
nnoremap S J
vnoremap S <Nop>
" map l --> s
nnoremap l s
vnoremap l s
nnoremap l s
vnoremap l s
" map HT --> half page up/down
nnoremap H <C-D>
vnoremap H <C-D>
nnoremap T <C-U>
vnoremap T <C-U>
" map mM --> nN -- since n taken over
nnoremap m n
vnoremap m n
nnoremap M N
vnoremap M N
" map e,ee,EE --> d,dd,DD -- since dD taken over
nnoremap e d
vnoremap e d
nnoremap ee dd
vnoremap ee dd
nnoremap EE DD
vnoremap EE DD
" map E --> C -- instead of mapping E --> D
nnoremap E C
vnoremap E C
" map kK --> eE -- since eE taken over
nnoremap k e
vnoremap k e
nnoremap K E
vnoremap K E
" unmap jJ -- no longer used (dvorak)
nnoremap j <Nop>
vnoremap j <Nop>
nnoremap J <Nop>
vnoremap J <Nop>
" map meta-d/n --> :bprev/:bnext
nnoremap <M-d> :bprev<CR>
nnoremap <M-n> :bnext<CR>
" map g* --> language server functions
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gz <Plug>(coc-references)
nmap <silent> gf <Plug>(coc-format-selected)
xmap <silent> gf <Plug>(coc-format-selected)
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gh :call <SID>doHover()<CR>
" map gl --> git blame
vmap <silent> gl :Gblame<CR>
" map <Leader>a* --> tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
"----[ override file types ]------------------------
autocmd BufNewFile,BufRead .*config,*.config,config
  \ setlocal filetype=gitconfig
autocmd BufNewFile,BufRead *.bolt
  \ setlocal filetype=typescript
autocmd BufNewFile,BufRead *.cql
  \ setlocal filetype=cql
autocmd BufNewFile,BufRead *.gradle,*.groovy
  \ setlocal filetype=groovy
autocmd BufNewFile,BufRead *.osgjs,*.osgjs.gz
  \ setlocal filetype=json
autocmd BufNewFile,BufRead *.go.tpl,*.peg,*.qtpl
  \ setlocal filetype=go
autocmd BufNewFile,BufRead *.gunk
  \ setlocal filetype=gunk syntax=go
autocmd BufNewFile,BufRead *.gltf
  \ setlocal filetype=gltf syntax=json
"----[ override file settings ]---------------------
autocmd FileType
  \ anko,bzl,cmake,groovy,html,javascript,javascript.jsx,json,jsx,proto,ps1,ruby,sh,sql,text,typescript,vim,xml,yaml
  \ setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType
  \ gitconfig
  \ setlocal shiftwidth=2 tabstop=2 softtabstop=2 noexpandtab
autocmd FileType
  \ text
  \ setlocal syntax=markdown
"----[ forced overrides for other issues ]----------
autocmd FileType *
  \ setlocal noautoindent nottimeout ttimeoutlen=0
autocmd FileType haxe
  \ setlocal smartindent
autocmd BufWritePre *.go
  \ :silent call CocAction('runCommand', 'editor.action.organizeImport')
"----[ strip trailing whitespace on save ]----------
autocmd FileType
  \ c,cmake,cpp,cql,cs,css,git,gitcommit,gitconfig,gradle,groovy,haxe,html,ice,java,javascript,markdown,perl,php,python,ruby,sh,sql,vcl,vim,xml,yaml,yml
  \ autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
"----[ always jump to last cursor position ]--------
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif
