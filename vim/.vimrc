set nocompatible
set t_ut=
filetype off

set rtp+=~/.vim/bundle/Vundle.vim,~/.vim/bundle/vim-projectroot

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'Tagbar'
Plugin 'junegunn/vim-easy-align'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'

if filereadable(projectroot#guess() . '.clang_complete')
    Plugin 'Rip-Rip/clang_complete'
    if has('win32')
        let g:clang_library_path = glob('~') . '/.vim/bundle/YouCompleteMe/third_party/ycmd'
    end
else
    " do not load clang_complete
    let g:clang_complete_loaded = 0
    Plugin 'Valloric/YouCompleteMe.git'
endif

Plugin 'kien/ctrlp.vim'
Plugin 'ervandew/supertab'

" snip mate plugin and dependencies
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

Plugin 'honza/vim-snippets'
Plugin 'taglist.vim'
Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
Plugin 'cscope_macros.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'flazz/vim-colorschemes'
Plugin 'dbakker/vim-projectroot'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'a.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'elzr/vim-json'
Plugin 'marijnh/tern_for_vim'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'einars/js-beautify'
Plugin 'vim-ctrlspace/vim-ctrlspace.git'
Plugin 'fatih/vim-go.git'
Plugin 'SirVer/ultisnips'
"Plugin 'jiangmiao/auto-pairs'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'alexshen/vim-glsl.git'
Plugin 'rhysd/vim-clang-format'
Plugin 'mbbill/undotree'

call vundle#end()
filetype plugin indent on
set modeline
" breaking for characters greater than 255, such as Chinese
" join comment lines
set fo+=mj

" cmd height 2
set ch=2

set mousehide       " Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch
endif

" Check if a font is available
function! HasFontInstalled(font)
    if executable('fc-list') != 1
        return 0
    endif

    let l:fcList = system('fc-list')
    if match(l:fcList, '\<' . a:font . ':') != -1
        return 1
    endif

    return 0
endfunction

set langmenu=en_US
let $LANG='en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

if has('gui_win32')
    " au GUIEnter * simalt ~x
    " full screen
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

    "set guifont=Consolas:h10
    set guifont=Source_Code_Pro:h9
elseif has('unix') || has('macunix')
    set ffs=unix
    if has('gui_gtk2')
        if HasFontInstalled('Ubuntu Mono')
            set guifont=Ubuntu\ Mono\ 10
        elseif HasFontInstalled('Consolas')
            set guifont=Consolas\ 11
        endif
    endif
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"colorscheme desertEx
" set the background base on time
if $VIM_BACKGROUND_TIMED == "1"
    if strftime("%H") < 18
      set background=light
    else
      set background=dark
    endif
else
    set background=dark
endif
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
colorscheme solarized
"colorscheme mrdark
"set guifont=courier_new:h10
"set guifont=Lucida_Console:h10
"set guifont=Dina:h10
"set guifont=Bitstream_Vera_Serif:h10
"set guifont=Triskweline:h10
"set guifont=ProggyCleanSZ:h11

nnoremap <Leader>bd :set background=dark
nnoremap <Leader>bl :set background=light


set noerrorbells visualbell t_vb=
set ignorecase smartcase
set smarttab
set encoding=utf-8
set backspace=indent,eol,start
set number
set relativenumber
set guioptions-=T " no tool bar
set incsearch
set ruler
" g0, indent public, private
" :0, indent case label
" l1, align with the case label
" t0, don't indent function return type
" (0, line up the first character with the unclose parathese
set cindent cino+=g0,:0,l1,t0,(0

"match xml or html tags
set mps+=<:>

" disable win alt keys
set wak=no

filetype plugin on
filetype indent on
let mapleader = ','

" super tab, user defined completion
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestEnhanced = 1
set completeopt=longest,menuone

" 1. search tags in the directory where the current file is
" 2. search in the current working directory
" 3. search upward until the root
" See file-search, tags-option for details
set tags+=./tags,tags;

imap <C-BS> <C-W>
imap <C-DEL> <ESC>lcw
" replace tab with whitespaces
nmap \t :retab<CR>
" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
noremap ; :
noremap : ;
" allow uppercase commands...
cnoremap W w
cnoremap Q q

autocmd FileType text syn match TextTag "\*[^* \t]\+\*"
autocmd FileType text syn match TextJump "|[^* \t]\+|"

hi def link TextTag String
hi def link TextJump Comment

" taglist
let Tlist_WinWidth = 56 
" show only the current file
let Tlist_Show_One_File = 1
" let Tlist_Use_Right_Window = 1

" Force all shell scripts to be recognized as bash scripts
let g:is_bash = 1

" Enable <c-h,j,k,l> to navigate among windows
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l

" Tagbar
" make it appear on the left by default
let g:tagbar_left = 1
nnoremap <silent> <A-9> :TagbarToggle<CR>

" CtrlP
let g:ctrlp_lazy_update = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.(git|hg|svn)|obj$',
    \ 'file': '\v\.(exe|so|obj|swp|ii|user|suo)',
    \ }
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0
if executable("ag")
    let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'
endif


noremap <silent> <Leader>f :CtrlP<CR>
noremap <silent> <Leader>t :CtrlPTag<CR>
noremap <silent> <Leader>s :CtrlPTag<CR>
noremap <silent> <Leader>m :CtrlPMRU<CR>
noremap <silent> <Leader>b :CtrlPBuffer<CR>
noremap <silent> <Leader>r :CtrlPClearCache<CR>
" visual assist style map
noremap <silent> <A-S-o> :CtrlP<CR>
noremap <silent> <A-S-s> :CtrlPTag<CR>

" Ycm
let g:ycm_server_keep_logfiles = 1
let g:ycm_confirm_extra_conf = 0
"let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_filetype_blacklist = { 'tex' : 1, 'json' : 1 }
"let g:ycm_filetype_specific_completion_to_disable = { 'tex' : 1 }
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_complete_in_comments = 1
set pvh=7
if has('win32')
    let g:ycm_key_invoke_completion = '<C-S-Space>'
    " on windows, csharp server cannot be terminated properly,
    " specifying a port to force reusing the existing server.
    let g:ycm_csharp_server_port = 13579
endif

autocmd FileType c,cpp,objc,objcpp,cs,go,javascript,python,rust,typescript nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
autocmd FileType c,cpp,objc,objcpp,cs,go,python,rust nnoremap <Leader>gD :YcmCompleter GoToDeclaration<CR>
autocmd FileType c,cpp,objc,objcpp nnoremap <Leader>gi :YcmCompleter GoToInclude<CR>

" SnipMate
"imap <C-J> <Plug>snipMateNextOrTrigger
"smap <C-J> <Plug>snipMateNextOrTrigger

" remap to avoid conflict with mappings for window navigation
nmap <C-N> <Plug>IMAP_JumpForward
vmap <C-N> <Plug>IMAP_JumpForward
"imap <C-N> <Plug>IMAP_JumpForward

" Latex-Suite
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode -shell-escape $*'
let g:Tex_ViewRule_pdf = 'mupdf'

" clang_complete
let g:clang_snippets = 1

" enhanced cpp highlight
let g:cpp_class_scope_highlight = 1
" let g:cpp_experimental_template_highlight = 1

" a.vim
" : not working with meta-key, don't know why
nmap <silent> <Leader>a ;A<CR>
imap <silent> <Leader>a ;A<CR>

let g:alternateExtensions_h = "cpp,cxx,cc,CC,c"
let g:alternateExtensions_H = "CPP,CXX,CC,C"

" airline
let g:airline#extensions#tabline#buffer_idx_mode = 1
" This is slow, so disable it
let g:airline#extensions#tagbar#enabled = 0
" make sure airline is always visible
set laststatus=2

" tern
let g:tern_show_signature_in_pum = 1

" vim-jsbeautify
autocmd FileType javascript noremap <buffer> <Leader>ff :call JsBeautify()<cr>
autocmd FileType javascript vnoremap <buffer> <Leader>ff :call RangeJsBeautify()<cr>

" nerd tree
nnoremap <silent> <Leader>nd :NERDTree<CR>
nnoremap <silent> <Leader>nf :NERDTreeFind<CR>
nnoremap <silent> <Leader>nc :NERDTreeClose<CR>

" easy align
vmap <CR> <Plug>(EasyAlign)

" ctrlspace
set hidden
set showtabline=0
let g:airline_exclude_preview = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceIgnoredFiles = '\v[\/](tmp|temp|build)[\/]'

nnoremap <silent> <Leader>, :CtrlSpace<CR>
nnoremap <silent> <Leader>/ :CtrlSpace /<CR>
nnoremap <silent> <Leader>o :CtrlSpace o/<CR>
hi link CtrlSpaceNormal   Normal
hi link CtrlSpaceSelected PMenu
hi link CtrlSpaceStatus   StatusLine
hi link CtrlSpaceSearch   Type
if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

function! CreateDirIfNotExist(dir)
    if ! isdirectory(a:dir)
        call mkdir(a:dir)
    endif
endfunction

" setup the backup directories
call CreateDirIfNotExist($HOME . '/.vim/backup/')
call CreateDirIfNotExist($HOME . '/.vim/swap/')
call CreateDirIfNotExist($HOME . '/.vim/undo/')

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

set ttimeoutlen=0 timeoutlen=1000

" map meta key
let c='a'
while c <= 'z'
    exec "set <M-".c.">=\<Esc>".c
    exec "nmap \<Esc>".c." <M-".c.">"
    exec "imap \<Esc>".c." <M-".c.">"
    let c = nr2char(1+char2nr(c))
endw

" show keystrokes in status line
set showcmd

" use i-beam cursor in insert mode, works in iTerm2 but not in Terminal
"if empty($TMUX)
  "let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  "let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  "let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"else
  "let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  "let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  "let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
"endif

set tw=100

augroup ClangFormatSettings
    autocmd!
    " map to <Leader>cf in C++ code
    autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
    autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
augroup END

nnoremap <Leader>u :UndotreeToggle<CR>
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

set splitbelow
