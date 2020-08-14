" Debug
" :map
" :command

set hlsearch
set backspace=2
set autoindent
set ruler
set showmode
"set rnu
set bg=dark
set ff=unix

set nocp

set cscopequickfix=s-,c-,d-,i-,t-,e-
set number
set mouse=a
"set guifont=Courier\ New\ Bold\ 11
set guifont=Consolas:h20
"set guifont=consolas:h15
set t_Co=256

set splitbelow
set splitright

"disable the background color erase fix color issues with terminal multiplexers like screen and tmux
if &term =~ '256color'
    set t_ut=
endif

" run 'ctags -R *' command to create the tags file
"set tags=./tags,tags;
let g:autotagTagsFile=".tags"

set complete=.,w,b,] " need ctags file

let Gtags_Auto_Update = 1
let GtagsCscope_Auto_Map = 1
let g:ctrlp_cmd = 'CtrlP .'
let g:acp_completeOption = &complete

let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
"let g:miniBufExplMapWindowNavArrows = 1

" airline file buffer
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ============================ Markdown =============================
let g:vim_markdown_new_list_item_indent = 3
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_math = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 6
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_conceal = 0

" :Toc  Create a quickfix vertical window navigable table of contents with the headers.
" :Toch Same as :Toc but in an horizontal window.
let g:vim_markdown_toc_autofit = 1

" ============================ Instant Markdown =====================
" Installation
" sudo apt-get install npm
" sudo npm -g install instant-markdown-d

let g:instant_markdown_autostart = 0
" trigger preview  :InstantMarkdownPreview
" stop it          :InstantMarkdownStop

"let g:instant_markdown_slow = 1
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_python = 1
let g:instant_markdown_mathjax = 1
let g:instant_markdown_autoscroll = 0
let g:instant_markdown_port = 8888
let g:instant_markdown_browser = "firefox --new-window"

" ============================ AutoSave =============================
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_events = ["InsertLeave", "TextChanged"]

"let g:auto_save_write_all_buffers = 1  " write all open buffers as if you would use :wa

" ============================ Syntastic ============================
" :h syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_c_checkers = [ 'gcc', 'make' ]
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = '-std=gnu11 -w'

":echo g:syntastic_c_compiler_options
":let g:syntastic_c_compiler_options = ' ... '

if filereadable("inc/bsp/config.h")
    let g:syntastic_c_compiler_options =
            \'-include inc/bsp/config.h -std=gnu11 -w'
            "'-include inc/bsp/config.h -std=gnu11 -W -Wall -Wextra -Wpedantic'
endif

"Show the content of function
":function SynCfgCheck()
" Execute function
":call SynCfgCheck()

function! SynCfgCheck()
    if filereadable("inc/bsp/config.h")
        echo "config.h exists"
        let g:syntastic_c_compiler_options =
                \'-include inc/bsp/config.h -std=gnu11 -w'
    else
        echo "config.h not exists"
    endif
endfunction


let g:syntastic_c_no_default_include_dirs = 1
let g:syntastic_c_no_include_search = 0
let g:syntastic_c_check_header = 1
let g:syntastic_c_config_file = '.asli_syntastic_c_config'
"let g:syntastic_c_include_dirs = [ 'inc', 'includes' ]

" python pylint
"let g:syntastic_python_checkers = ['pylint']
" python flake8
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_python_exec = 'python3'
" ===============================================================================

" show tab and space characters
set list
set listchars=tab:^.,trail:$
" setup tab, shift width and backspace tab
set ts=4 sw=4 sts=4
" tab expand to 4 space
set expandtab
" expand exist tab to space
retab

set lazyredraw
set ttyfast

" turn on cursorline
set cursorline

" turn off cursorline
"set cursorline!
"set nocursorline


" no backup & swap files
set nobackup
set nowritebackup
set noswapfile

"set cscopeprg=gtags-cscope " need gtags files
"set cscopetag
"if has("cscope")
"    " add any gtags-cscope database in current directory
"    if (&csprg =~# "gtags-cscope") && filereadable("GTAGS")
"        cs add GTAGS
"    endif
"endif

filetype plugin on
filetype indent on

syntax enable
syntax on

" ============================ theme and status line ============================
colorscheme 256-jungle
"colorscheme wombat256mod
"colorscheme buddy
"colorscheme molokai
"colorscheme onedark

" overwrite colorscheme setting(xterm-256)
"hi Comment      ctermfg=244     ctermbg=None    cterm=None
"hi Comment      ctermfg=29      ctermbg=None    cterm=None
hi Comment      ctermfg=131     ctermbg=None    cterm=None
hi Normal       ctermfg=252     ctermbg=234     cterm=None
hi Constant     ctermfg=34      ctermbg=None    cterm=None
hi Boolean      ctermfg=166     ctermbg=None    cterm=Bold
hi cDefine      ctermfg=96      ctermbg=None    cterm=Bold

hi cursorline   ctermfg=None    ctermbg=16      cterm=None

" if else switch while for do case default goto break return continue asm
" + - * / = [] | & % . -> ! ~ > <
"hi Statement    ctermfg=167     ctermbg=None    cterm=Bold

" highlight tab and space
hi SpecialKey   ctermfg=199     ctermbg=None    cterm=None

" ============================= auto ====================================
" auto reload vimrc, FAIL
augroup reload_vimrc
    au!
    au BufWritePost .vimrc source $MYVIMRC
augroup END

" trim extra space before buf write
" remove all trailing whitespace whenever you save the file
augroup trim_space
    au!
    au BufWritePre * %s/\s\+$//e
    au BufWritePre * %s/\r//e
augroup END

" ============================ key map ============================
" insert #if 0 - #endif around block of code
" type ma mark start line
" then move to the line that should be last line and press ;'
map ;' <Esc>:AutoSaveToggle<CR>mz'aO<Esc>i#if 0<Esc>'zo<Esc>i#endif<Esc>j:w<CR>:AutoSaveToggle<CR>
map ;; <Esc>:AutoSaveToggle<CR>mz'aO<Esc>i#if (<C-r>" == 1)<Esc>'zo<Esc>i#endif<Esc>j:w<CR>:AutoSaveToggle<CR>

vmap ;' o<Esc>:AutoSaveToggle<CR>O#if 0<Esc>'>o#endif<Esc>j:w<CR>:AutoSaveToggle<CR>
vmap ;; o<Esc>:AutoSaveToggle<CR>O#if (<C-r>" == 1)<Esc>'>o#endif<Esc>j:w<CR>:AutoSaveToggle<CR>
" delete #if 0 - #endif
vmap '; o<Esc>:AutoSaveToggle<CR>dd<Esc>'><Esc>dd:w<CR>:AutoSaveToggle<CR>


" cscope command "
"map <f7> :cn<CR>
"map <f6> :cp<CR>
"map <f5> :cs find s <C-R>=expand("<cword>")<CR><CR> :cw<CR>

" switch paste mode"
set pastetoggle=<f9>

" reload vimrc without restarting vim
"map <silent> <f8> :so $MYVIMRC<CR>
map <f8> :so $MYVIMRC<CR>

" replace tab to spaces
map <silent> <f5> :set et<CR>:retab<CR><Esc>

nnoremap <silent> <f4> :e!<CR><Esc>:!gtags -v<CR><Esc>:!ctags -R *<CR><Esc>
nnoremap <silent> <f3> :NERDTreeToggle<CR>
"nnoremap <silent> <f3> :MBEToggle<CR> " Minibuffer
nnoremap <silent> <f2> :TlistToggle<CR>

" composing in normal mode (comflict with <C-i>)
"nmap    <tab>   v>
"nmap    <s-tab> v<
" composing in virtual mode
vmap    <tab>   >gv
vmap    <s-tab> <gv

"let mapleader = ","

" access system clipboard
"noremap <leader>x "+x
"noremap <leader>y "+y
"noremap <leader>p "+gp
"noremap <leader>dd "*dd
"noremap <leader>yy "*yy

" pane navigation with arrow key
noremap <C-Up>    <C-w>k
noremap <C-Down>  <C-w>j
noremap <C-Left>  <C-w>h
noremap <C-Right> <C-w>l

" pane navigation with Ctrl-[hjkl]
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"inoremap (      ()<Esc>i
"inoremap \"      \""<Esc>i
"inoremap '      ''<Esc>i
"inoremap [      []<Esc>i
inoremap {<CR>  {<CR>}<Esc>ko

" ReplaceWithRegister
xmap r <Plug>ReplaceWithRegisterVisual

" quickly highlight
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
" automatically higlight word under cursor
nmap <Space>j <Plug>(quickhl-cword-toggle)

" ============================ specific file type ===========================

"autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
"autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
"autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd

autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    " .sh
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    " python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    normal G
    normal o
    normal o
endfunc
" =================================================================

" helper function to toggle hex mode
function! ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        silent :e " this will reload the file without trickeries
        "(DOS line endings will be shown entirely )
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd -g 1
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

noremap <leader>hm :call ToggleHex()<CR>


" vim -b : edit binary using xxd-format!
augroup Binary
    au!
    au BufReadPre   *.bin let &bin=1
    au BufReadPost  *.bin if &bin | call ToggleHex()
    au BufReadPost  *.bin set ft=xxd | endif
    au BufWritePre  *.bin if &bin | call ToggleHex()
    au BufWritePre  *.bin endif
    au BufWritePost *.bin if &bin | call ToggleHex()
    au BufWritePost *.bin set nomod | endif
augroup END

":PlugInstall
":PlugUpdate
":PlugClean

call plug#begin('~/.vim/plugged')
"silent call plug#begin('~/.vim/plugged')
" silent mode, errors are not displayed
" (apply this mode if there is no internet connection
"
"Plug 'fholgado/minibufexpl.vim'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/256-jungle'
Plug 'vim-airline/vim-airline'
"Plug 'chazy/cscope_maps'
Plug 'aceofall/gtags.vim'

" replace text with the contents of a register
Plug 'vim-scripts/ReplaceWithRegister'

" file system explorer
Plug 'scrooloose/nerdtree'

" Full path fuzzy file finder, search files
" Press <F5> to purge the cache for the current directory to get new files,
" remove deleted files and apply new ignore options.
Plug 'ctrlpvim/ctrlp.vim'

" syntax highlight
"Plug 'sheerun/vim-polyglot'
Plug 'NLKNguyen/c-syntax.vim'

" code-completion
Plug 'vim-scripts/AutoComplPop'

" quickly highlight
Plug 't9md/vim-quickhl'

" Syntastic, syntax checking plugin, lint
Plug 'scrooloose/syntastic'
Plug 'nvie/vim-flake8'

" Add parentheses, brackets, quotes ...
" select text and type Sb (surround-braces), or S) (note the capital S !).
" cs"' (change-surround " to '). Or you can completely delete quotes by typing
" ds"  (delete-surround ").
" There is a difference between typing '(' and ')', '(' would pad a space in the braces.
Plug 'tpope/vim-surround'
" The . command will work with ds, cs, and yss if you install repeat.vim.
Plug 'tpope/vim-repeat'

" AutoSave - automatically saves changes to disk without having to use :w
Plug '907th/vim-auto-save'

" Markdown Syntax highlighting
Plug 'plasticboy/vim-markdown'
" Instant Markdown previews from Vim
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}


call plug#end()

