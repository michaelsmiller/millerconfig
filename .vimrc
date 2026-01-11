" Plugins
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " required

Plugin 'tpope/vim-commentary'           " for comments
Plugin 'tpope/vim-fugitive'             " for vimdiff merge conflicts
Plugin 'tpope/vim-obsession'            " for saving sessions (useful in tmux)
Plugin 'vim-scripts/DoxygenToolkit.vim' " for javadoc stuff
Plugin 'Galicarnax/vim-regex-syntax'    " highlights regexes
Plugin 'kien/ctrlp.vim'                 " Searching, seems fun, should learn how to use it.
Plugin 'itchyny/lightline.vim'          " statusline
Plugin 'junegunn/fzf'                   " fzf

" Syntax Highlighting
Plugin 'othree/html5.vim'               " HTML
Plugin 'pangloss/vim-javascript'        " Javascript
Plugin 'evanleck/vim-svelte'            " Svelte
Plugin 'vim-python/python-syntax'       " Python
Plugin 'vim-scripts/indentpython.vim'   " fix auto-indent after multiline function signature
Plugin 'cespare/vim-toml'               " toml
Plugin 'bfrg/vim-cpp-modern'            " C++
Plugin 'neovimhaskell/haskell-vim'      " Haskell
Plugin 'Tetralux/odin.vim'              " Odin
Plugin 'jansedivy/jai.vim'              " Jai
Plugin 'beyondmarc/glsl.vim'            " GLSL
Plugin 'shmup/vim-sql-syntax'           " SQL
Plugin 'ekalinin/Dockerfile.vim'        " Dockerfile
Plugin 'leafgarland/typescript-vim'     " Typescript
Plugin 'davidhalter/jedi-vim'

call vundle#end()            " required
filetype plugin indent on    " required

" My leader
let mapleader=","


" L&F
function! GitBranchIfEnoughSpace()
  return winwidth(0) > 85 ? FugitiveHead() : ''
endfunction
function! GetSyntax()
  return winwidth(0) > 40 ? &syntax : ''
endfunction

set laststatus=2 " Necessary for status bar to actually display for some reason
let g:lightline = {
  \ 'colorscheme': 'apprentice',
  \ 'active': {
  \   'left': [ ['mode', 'paste'],
  \             ['gitbranch', 'readonly', 'filename', 'modified']],
  \   'right': [ ['lineinfo'],
  \             ['percent'],
  \             ['syntax'] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'GitBranchIfEnoughSpace',
  \   'syntax': 'GetSyntax'
  \ },
  \ }
set noshowmode " We don't need VIM to display the mode if lightline is already doing it
set shortmess+=F " This turns off info about the file when it's opened

colorscheme apprentice
" Memes: anderson, nord
" Legit: alduin, angr, afterglow, apprentice

set cursorline " highlights current line
set scrolloff=5 " keep 5 lines above and below cursor
set linebreak   " don't wrap text in middle of word
nnoremap <leader><S-H> :silent execute "set colorcolumn=" . (&colorcolumn == "" ? "88" : "")<CR>

" Needed to set this to view certain embedded C files
set nomodeline


" Tabs
set autoindent " automatically indents next line

set number " line numbers
set showcmd " shows latest command
set lazyredraw " Doesn't redraw screen during macros or something
set showmatch " highlights matching parens

" Search
set incsearch " search as new chars typed
set hlsearch " highlights matches
" Uncomment if you want case insensitivity
" set ignorecase
" set smartcase

function! GoFmt()
  let l:syn = &syntax
  if (l:syn == 'go')
    let filepath = expand('%:p')
    call system('gofmt ' . filepath)
    execute "normal! :edit!\<CR>:!clear"
    " echom "File " . filepath . " written and gofmt run"
  endif
endfunction
" augroup go_settings
"   autocmd!
"   autocmd BufWritePost *.go call GoFmt()
" augroup END

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

set tags=.tags " for ctags in code

" Searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.egg-info/**,.git,*.o,.tags

" Folds
set foldenable " enables folding
set foldlevelstart=10 " makes sure things are unfolded by default
set foldnestmax=10
set foldmethod=indent

" Auto-detect virtual environment in project root
function! SetPythonEnvInJedi()
  let l:venv = finddir('.venv', '.;')
  if !empty(l:venv)
    let l:python_path = fnamemodify(l:venv, ':p') . 'bin/python3'
    if filereadable(l:python_path)
      let g:jedi#environment_path = fnamemodify(l:venv, ':p')
    endif
  endif
endfunction

augroup PythonVenv
  autocmd!
  autocmd FileType python call SetPythonEnvInJedi()
augroup END

" Jedi
let g:jedi#completions_enabled = 0 " no auto-completions
let g:jedi#popup_on_dot = 0 " no popups when you type a .
let g:jedi#show_call_signatures = "2" " call signatures out of the way
let g:jedi#usages_command = "" " default is <leader>n which I use


syntax enable  " syntax highlighting
" Commands for odd filetypes
augroup type_setting
  autocmd!
  " Variants of shell scripts
  autocmd BufNewFile,BufRead *.colors set syntax=sh " For colors variables for bash_profile
  autocmd BufNewFile,BufRead *.bash_* set syntax=sh " e.g. .bash_private
  autocmd BufNewFile,BufRead *.env    set syntax=sh
  autocmd BufNewFile,BufRead *.env.*  set syntax=sh

  autocmd BufNewFile,BufRead *.cuh set syntax=cpp " CUDA header files
  autocmd BufNewFile,BufRead *.h.* set syntax=cpp " For vimdiff
  autocmd BufNewFile,BufRead *.cpp.* set syntax=cpp " For vimdiff
  autocmd BufNewFile,BufRead *.vars set syntax=make " make.vars for terachem
  autocmd BufNewFile,BufRead *.inc set syntax=make " Makefiles sometimes include these
  autocmd BufNewFile,BufRead *.vert,*.frag,*.glsl set syntax=glsl330 " GLSL (shading language)
  autocmd BufNewFile,BufRead *.odin set syntax=odin " For Odin programming language
  autocmd BufNewFile,BufRead *.jai  set syntax=jai " For Jai
  autocmd BufNewFile,BufRead *.rec  set syntax=cpp
  autocmd BufNewFile,BufRead *.toml  set syntax=toml " TOML
  autocmd BufNewFile,BufRead *.sql  set syntax=sql   " SQL
  autocmd BufNewFile,BufRead *.condarc  set syntax=yaml   " Anaconda settings are in YAML for some reason
  autocmd BufNewFile,BufRead *.pyre_configuration  set syntax=json   " pyre is JSON
  autocmd BufNewFile,BufRead *.dockerignore  set syntax=conf   " Dockerignore file
  autocmd BufNewFile,BufRead go.mod  set syntax=gomod   " go.mod files
  autocmd BufNewFile,BufRead talosconfig  set syntax=yaml   " Talos client config
  autocmd BufNewFile,BufRead alembic.ini  set syntax=toml   " Alembic config
  autocmd BufNewFile,BufRead .tmux.*  set syntax=tmux   " tmux config files
augroup END

" For overriding defaults in vim-commentary plugin
augroup comment_strings
  autocmd!
  autocmd Syntax glsl330 set commentstring=//\ %s
  autocmd Syntax cpp set commentstring=//\ %s
  autocmd Syntax c   set commentstring=//\ %s
  autocmd Syntax cfg set commentstring=#\ %s
  autocmd Syntax jai set commentstring=//\ %s
  autocmd Syntax sql set commentstring=--\ %s
  autocmd Syntax sh  set commentstring=#\ %s
  autocmd Syntax toml set commentstring=#\ %s
  autocmd Syntax svelte set commentstring=<!--\ %s\ -->
  " Newline should make comment on the next line
  autocmd Syntax python set formatoptions+=ro
  autocmd Syntax go     set formatoptions+=ro
augroup END

augroup pair_matching
  autocmd!
  autocmd Syntax cpp set matchpairs+=<:> " Matching between angle brackets
augroup END

" Make sure file opens at same place as where it was closed
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif

augroup tab_defaults
  autocmd!
  " By default, tabstop, soft tabstop, and shiftwidth should be 2 for c files
  autocmd Syntax * setlocal ts=2 sts=2 sw=2 expandtab " Makefiles need to have tabs this way
  " Python, where that shit matters
  autocmd Syntax python setlocal ts=4 sts=4 sw=4
  autocmd Syntax markdown setlocal ts=4 sts=4 sw=4
  autocmd Syntax go     setlocal ts=4 sts=4 sw=4
  " In Makefiles, tabs should not be expanded and only want 4 spaces
  autocmd Syntax make setlocal ts=8 sts=0 sw=0 noexpandtab " Makefiles need to have tabs this way
  autocmd Syntax automake setlocal ts=8 sts=0 sw=0 noexpandtab
  " In ssh config files, I think tabs shouldn't be expanded again.
  autocmd Syntax sshconfig setlocal ts=4 sts=0 sw=0 noexpandtab " I think it matters for sshconfig as well
augroup END

" Syntax highlighting
highlight BadWhitespace ctermbg=red guibg=darkred
augroup syntax_highlighting
  " autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.cu,*.cpp,*.jai,*.sql match BadWhitespace /\s\+$/
  autocmd BufRead,BufNewFile *.pyw,*.c,*.h,*.cu,*.cpp,*.jai,*.sql match BadWhitespace /\s\+$/
  autocmd Syntax python syn keyword pythonStatement match case
  autocmd Syntax python syn keyword pythonTodo      NOTE contained
  autocmd Syntax python let python_highlight_all=1

  " Jai keywords
  autocmd Syntax jai    syn keyword JaiIf ifx
  autocmd Syntax jai    syn keyword jaiUsing push_context
  autocmd Syntax jai    syn keyword jaiIt it_index
  autocmd Syntax jai    syn keyword JaiEnum enum_flags
  autocmd Syntax jai    syn keyword JaiReturn break continue case

  " Numbers that aren't highlighted correctly normally
  autocmd Syntax jai    syn match   jaiInteger       "\<\d[0-9_]*\>" display
  autocmd Syntax jai    syn match   jaiBinaryInteger "\<0b[01][01_]*\>" display
  autocmd Syntax jai    syn match   jaiHexFloat      "\<0h[0-9A-Fa-f][0-9A-Fa-f_]*\>" display
  autocmd Syntax jai    highlight def link jaiBinaryInteger Number
  autocmd Syntax jai    highlight def link jaiHexFloat      Float

  " SQL keywords that need highlighting
  autocmd Syntax sql  syn keyword sqlKeyword   natural limit type
  autocmd Syntax sql  syn keyword sqlStatement set
  autocmd Syntax sql  syn keyword sqlOperator  elseif elsif returns declare language
  autocmd Syntax sql  syn keyword sqlType      record integer double timestamp
augroup END

" Checks current syntax highlighting group under cursor
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Syntax highlighting specifics
let g:python_highlight_all = 1
" let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0

" Highlighting for Haskell, maybe I should remove since I don't use Haskell
" anymore...
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent = 2 " default

" Selection macros
nnoremap <leader>v `[v`]

" For modifying d, x, v, etc.
onoremap p i(
onoremap q i"

" allows cursor change in tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" Abbreviations
iabbrev mmail michaelsmiller2@gmail.com
" Common spelling errors
iabbrev waht what
iabbrev tehn then
iabbrev incldue include
iabbrev subsitution substitution
iabbrev sefl self
iabbrev NOne None
iabbrev fro for

" Automatically ends paste mode when leaving insert mode
au InsertLeave * set nopaste
noremap <leader>p :set paste<CR>i

" fast save
noremap <leader>w :w<CR>
noremap <leader>q :w<CR>:bd<CR>

" My own mappings
"
" for loops
" Recursive implementation that works on arbitrary nested loops and fails
" gracefully
function! ExpandFor()
  let line = getline('.')
  let parts = split(line, " ")
  let N = len(parts)

  if N < 3
    return
  endif

  " Just care about first 3 things in the line
  let I = parts[0]
  let S = parts[1]
  let E = parts[2]
  let rest = join(parts[3:N], " ")
  let whitespace = strpart(line, 0, stridx(line,I))

  let l:syn = &syntax
  " echom l:syn . " is the syntax"
  if (l:syn ==# "c") || (l:syn ==# "cpp") || (l:syn ==# "cuda")
    " TODO: Add something for just c
    let statement = printf("for (size_t %s = %s; %s < %s; %s++) {", I, S, I, E, I)
    execute "normal! ^d$A" . statement . "\<CR>\<CR>\<BS>}\<Esc>kA" . whitespace . "\<Tab>" . rest
    execute "normal! :call ExpandFor()\<CR>"
  elseif l:syn ==# "fortran"
    let statement = printf("do %s = %s, %s", I, S, E)
    " execute "normal! ^d$A" . statement . "\<CR>\<CR>end do\<Esc>kA" . whitespace . "\<Tab>" . rest
    execute "normal! ^d$A" . statement . "\<CR>\<CR>end do\<Esc>kA\<Tab>" . rest
    execute "normal! :call ExpandFor()\<CR>"
  else
    echom "No match found for " . l:syn
  endif
endfunction
inoremap <C-F> <Esc>:call ExpandFor()<CR>A

" Add semicolon to end of current line while retaining current position
noremap ; mqA;<Esc>`q

" Match parens and other open/close things and puts cursor in the right place
" C-P for parens is what I always wanted. C-G is what is available for quotes
let g:ParenMatch = {'(': ')', '[': ']', '{': '}', '"': '"', '<': '>', "'": "'"}
function! CloseParens(opening)
  let l:ending = get(g:ParenMatch, a:opening, '0')
  return printf("%s%s\<Left>", a:opening, l:ending)
endfunction
inoremap <expr> <C-P> CloseParens('(')
inoremap <expr> <C-G> CloseParens('"')

" Very important mappings right here
inoremap jk <Esc>


" Movement
" Linebreaks
noremap j gj
noremap k gk

" Movement in insert mode
inoremap <C-H> <Left>
inoremap <C-K> <Up>
inoremap <C-L> <Right>
inoremap <C-J> <Down>

" Easy switching between vim windows
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l

inoremap <C-W> <C-O><C-W>

" Prevents paste from overwriting register
vnoremap p pgvy

" Moving up and down
nnoremap <C-J> 5j
nnoremap <C-K> 5k

" Move to ends of line
nnoremap <S-H> ^
nnoremap <S-L> $

" make space shorthand for :noh
noremap <silent> <Space> :silent noh<Bar>echo<CR>

set mouse=a

" For quick run of some makefiles or whatever I need at the moment
nnoremap <leader>m :silent w<CR>:!clear&&python %:p<CR>
" nnoremap <leader>m :w<CR>:!clear&&jai -x64 %:p<CR>


" If we are editing file ~/dir/.../filename
"   this takes us to ~/dir/notes.txt
function! GoToNotes()
  let home_path = expand('~')
  let full_path = expand('%:p')
  let note_dir = matchstr(l:full_path, l:home_path . "/\[\^\/\]\*")

  if len(l:note_dir) > len(l:home_path)
    let note_path = printf("%s/notes.txt", l:note_dir)
    execute "normal! :e " . l:note_path . "\<CR>"
  else
    echom "Cannot open notes.txt: not in subdirectory of '" . l:home_path . "'"
  endif
endfunction
nnoremap <leader>n :silent w<CR>:call GoToNotes()<CR>


" sources and goes into vimrc - don't know why :noh is necessary
nnoremap <leader>s :source $MYVIMRC<CR> :silent noh<CR>
nnoremap <leader>e :e $MYVIMRC<CR>

" Goes to the next file over, not sure why S-Tab doesn't also work
nnoremap <leader><Tab> :bn<CR>

" For tabbing a line or selection with Tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <
vnoremap <Tab> >

" Copy a selection into system clipboard
vnoremap <C-C> ""y:call system("clip-inline", @")<CR>

" Relative numbers
nnoremap <C-N> :set number! <CR> :set relativenumber! <CR>
set number
set relativenumber

" Incredibly useful function that writes a header guard in TeraChem format.
" The variable is FILENAME_H_
function! WriteHeaderGuard()
  let filename = expand('%:t') " Gets filename
  let filename = substitute(filename, '\.', '_', 'g') " replace dots
  let filename = substitute(filename, '\(\w\)', '\u\1', 'g') " Uppercase
  let filename = printf("%s_", filename) " Add trailing underscore
  let guard_start = printf("#ifndef %s\<CR>#define %s\<CR>\<CR>", filename, filename)

  let pos = getpos('.')
  execute "normal! ggO\<Esc>v0xi" . guard_start
  execute "normal! Go\<CR>#endif"
  call setpos('.', pos)
endfunction
command! Guard call WriteHeaderGuard()


" Goes from file.cpp -> file.h and from file.h -> file.cpp
function! EnterOtherFile()
  let basename = expand('%:r')
  let ext = expand('%:e')
  " will assume other file exists
  let other_ext = "h"
  if l:ext == "h"
    let other_ext = "cpp"
  endif
  let filename = printf("%s.%s", basename, other_ext)
  execute "normal! :e " . filename . "\<CR>"
endfunction
" nnoremap <leader>h :call EnterOtherFile()<CR>

" Closes the current buffer without closing the others
command! Q bd

" vimdiff
" LO = LOCAL
" RE = REMOTE
nnoremap DH :diffget LO<CR>
nnoremap DL :diffget RE<CR>
nnoremap DQ :only<CR>
