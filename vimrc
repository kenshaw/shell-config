set runtimepath+=~/src/shell-config/vam
call vam#ActivateAddons(['vim-twig'])

"---------------------------------------------------
" disable vi compat
set nocompatible

" enable status info for xterms
set title
"---------------------------------------------------


"---------------------------------------------------
" enable syntax highlighting
syntax on

" enable autocompletetion based on syntax files
"au FileType * exe('setl dict+='.$VIMRUNTIME.'/syntax/'.&filetype.'.vim')

" clear syntax buffer sync
"autocmd BufEnter * :syntax sync fromstart
"---------------------------------------------------


"---------------------------------------------------
" incremental search and highlight search results
set incsearch
"set showmatch
"set hlsearch

" set clear search with <F3>
map <F3> :let @/ = "" <CR>

" use better regex's
"nnoremap / /\v
"vnoremap / /\v
"---------------------------------------------------


"---------------------------------------------------
" save info
set viminfo='50,\"1000,s100,:0,%,n~/.viminfo

" turn off modelines
set modelines=0

" ignore stuff
set wildignore=*.o,*.obj,*.bak,*.exe

" enable autoindenting
set autoindent

" set tab display width
set tabstop=4
set shiftwidth=4
set expandtab

" set a really big undo history
set history=1024

" smarter search
set ignorecase
set smartcase

" apply substitutions globally on %s
set gdefault

" some random settings
set encoding=utf-8

" keep cursor in center of screen
set scrolloff=40
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

"set visualbell
"set cursorline
set relativenumber

"set up undo information
if !isdirectory($HOME.'/.vimundo')
  silent !mkdir -p $HOME/.vimundo 2>&1 > /dev/null
  echo 'Created '.$HOME.'/.vimundo'
endif

set undodir=~/.vimundo
set undofile
"---------------------------------------------------


"---------------------------------------------------
" auto trim whitespace on save
"autocmd BufWritePre * normal mj <CR> :%s/\s\+$//e :normal `j
autocmd FileType c,cpp,java,php,js,pl autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
"---------------------------------------------------


"---------------------------------------------------
" use tabs as well as %s for matching brackets
nnoremap <tab> %
vnoremap <tab> %

" remap ; to : to save on hitting shift
nnoremap ; :
"---------------------------------------------------


"---------------------------------------------------
" When editing a file, always jump to the last cursor position and center that on the screen
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" dvorak remapping
" set langmap='q,\,w,.e,pr,yt,fy,gu,ci,ro,lp,/[,=],aa,os,ed,uf,ig,dh,hj,tk,nl,s\\;,-',\\;z,qx,jc,kv,xb,bn,mm,w\,,v.,z/,[-,]=,\"Q,<W,>E,PR,YT,FY,GU,CI,RO,LP,?{,+},AA,OS,ED,UF,IG,DH,HJ,TK,NL,S:,_\",:Z,QX,JC,KV,XB,BN,MM,W<,V>,Z?

"vmap sb "zdi<b><C-R>z</b><Esc> : wrap <b></b> around VISUALLY selected Text
"vmap st "zdi<?= <C-R>z ?><Esc> : wrap <?= ?> around VISUALLY selected Text

" svn blame stuff
vmap gl :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
