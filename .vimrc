" --- Plugins ---
call plug#begin('~/.vim/pack')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-system-copy'
Plug 'scrooloose/nerdtree'
Plug 'nvie/vim-flake8'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'chrisbra/unicode.vim'
Plug 'xuhdev/vim-latex-live-preview'

call plug#end()

" --- Editing A File ---
set encoding=utf-8
set ruler
set showmatch " Shows matching bracket
set noshowmode " Disables the "-- INSERT --" text below the status bar
set autoindent
set number " Line Number
set relativenumber " Calculates the lines away from cursor line
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start
set mouse=n " Enables the use of the mouse in normal mode
set mousehide " Hides the mouse when typing
set vb " Visual bell
filetype plugin indent on " File-based indentation
filetype on

au BufNewFile,BufRead *.story   setf story


" --- Vim Looks ---
syntax enable
set nowrap " Turns off line wrapping

" Special setup for text-based file formats
autocmd FileType markdown setlocal wrap
autocmd FileType text setlocal wrap

" Highlight everything at or over 80 columns for tex filetypes
autocmd FileType tex match Over80col /\%80v.\+/
autocmd FileType tex setlocal cc=80

" Python PEP8 implementation
" Highlight anything over 80 columns
autocmd FileType python match User1 /\%80v.\+/
autocmd FileType python setlocal cc=80
" Highlight any trailing whitespace
autocmd FileType python match ErrorMsg /\s\+$/

autocmd FileType python map <buffer> <F12> :call flake8#Flake8()<return>



function! Readonly()
    if &readonly || !&modifiable
	return ' [readonly]'
    else
	return ''
    endif
endfunction


" --- Color Scheme ---
set background=dark
hi Comment    ctermfg = 39                                  guifg = cyan
hi Special    ctermfg = 5                                   guifg = purple
hi PrePoc     ctermfg = 5                                   guifg = purple
hi Identifier ctermfg = 33                                  guifg = orange
hi Constant   ctermfg = 166                   cterm = bold  guifg = orange
hi ErrorMsg   ctermfg = white  ctermbg = red                guifg = white      guibg = red
hi Normal     ctermfg = 7                                   guifg = white      guibg = #3d3d3d

hi User1      ctermfg = 154    ctermbg = 22                 guifg = darkgreen  guibg = yellow
hi User2      ctermfg = 123    ctermbg = 97                 guifg = darkorange guibg = gold
hi User3      ctermfg = 214    ctermbg = 94                 guifg = gold       guibg = orangered
hi Over80col  ctermfg = 22     ctermbg = 154                guifg = darkgreen  guibg = yellow
hi NrmlClr    ctermfg = 15     ctermbg = 8                  guifg = white      guibg = #727272
hi InrtClr    ctermfg = 15     ctermbg = 28                 guifg = white      guibg = #43d31f
hi ReplClr    ctermfg = 015    ctermbg = 142                guifg = white      guibg = gold
hi VisuClr    ctermfg = 015    ctermbg = 61                 guifg = white      guibg = purple

" --- Color Scheme in hex ---
" User1       ctermfg = GreenYellow     (#afff00)   ctermbg = DarkGreen     (#005f00)
" User2       ctermfg = DarkSlateGray1  (#87ffff)   ctermbg = MediumPurple3 (#875faf)
" User3       ctermfg = Orange1         (#ffaf00)   ctermbg = Orange4       (#875f00)
" NrmlClr      ctermfg = White          (#ffffff)   ctermbg = Grey          (#808080)
" InrtClr      ctermfg = White          (#ffffff)   ctermbg = Green4        (#008700)
" ReplClr      ctermfg = White          (#ffffff)   ctermbg = Gold3         (#afaf00)
" VisuClr      ctermfg = White          (#ffffff)   ctermbg = SlateBlue3    (#5f5f87)

" Function to check for visual block
function CheckMode()
    if mode() ==? "\<C-v>"
        return 1
    else
        return 0
    endif
endfunction

" --- Status Line Setup ---
set laststatus=2 " The Statusline will always be there
set statusline=
set statusline+=%#NrmlClr#%{(mode()[0]==?'n')?'\ \ N\ ':''}  " Setting up the mode in the bottom left
set statusline+=%#InrtClr#%{(mode()[0]==?'i')?'\ \ I\ ':''}
set statusline+=%#ReplClr#%{(mode()[0]==?'r')?'\ \ R\ ':''}
set statusline+=%#VisuClr#%{(mode()[0]==?'v')?'\ \ V\ ':''}
set statusline+=%#VisuClr#%{(CheckMode())?'\ \ V\ ':''}
set statusline+=%#User1#
set statusline+=\ %f " Filepath relative to current directory
set statusline+=%{Readonly()}  " Is this file read only
set statusline+=%=  "  Everything after this is now on the right side
set statusline+=%y\ /\  " Adds the file type and a slash
set statusline+=%{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %#User3#
set statusline+=\ %l/%L\:\%c\  " Adds current line over total number of lines with the column number
set statusline+=%#User2#
set statusline+=\ %p%%\   " Adds the percentage through the document



" --- Shortcuts & Key Mappings ---
function ToggleNumber()
    if &nu == 1
	if &rnu == 1
	    set nornu
	else
	    set rnu
	endif
    else
	set nu
    endif

endfunction

function TurnOffNumbers()
    set nornu
    set nonu
endfunction

function ToggleSpell()
  if &spell == 1
    set nospell
  else
    set spell spelllang=en_gb
  endif
endfunction

function ToggleRedLine()
  if len(getmatches()) > 0
    match
    set cc=0
  else
    match Over80col /\%80v.\+/
    set cc=80
  endif
endfunction

" Press F2 to write
nnoremap <F2> <ESC>:w<return>

" Press F3 to exit without writing
nnoremap <F3> <ESC>:q<return>

" Press F4 to write and quit
nnoremap <F4> <ESC>ZZ

" F5 to toggle spell check
nnoremap <F5> <ESC>:call ToggleSpell()<return>

" F6 to toggle red line at col 80
nnoremap <F6> <ESC>:call ToggleRedLine()<return>

" Ctrl + F6 to highlight trailing whitespace
nnoremap <C-F6> <ESC>/\s\+$/<return>

" Ctrl + F8 and Ctrl + F7 to navigate tabs
nnoremap <F7> <ESC>:tabp<return>
nnoremap <F8> <ESC>:tabn<return>

" Brings up NERDTree with F9
nnoremap <F9> <ESC>:NERDTree<return>

" Press F10 to toggle relative numbers and Ctrl + F6 to turn them off entirely
nnoremap <F10> <ESC>:call ToggleNumber()<return>
nnoremap <C-F10> <ESC>:call TurnOffNumbers()<return>


" bk also acts as the escape key
inoremap bk <ESC>
inoremap bbk <ESC>:noh<return>

" --- Macros ---
let @u = 'i̲' " Underlining a character
let @e = 'i̅' " Overlining a character
let @o = 'o{}0k' " Curly brackets on the same column
let @a = 'A {}0k[4~'   " Curly brackets on different columns

let @c='i /\i◔ |◔| || \/|'   " Clippy
let @r='i_______________| l l l l l l ||_____________|'   " Rulere
let @d='i /‾\|◕ ◕|| ᴥ | \_/'   " Doggo
