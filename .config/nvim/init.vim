" --- Plug-ins ---
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'chrisbra/unicode.vim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'jbyuki/venn.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

" ---  Fuzzy finding ---
set path+=**
set wildmode=longest,list,full
set wildmenu
set wildignore+=*.pyc

" --- Editing a file ---
set encoding=utf-8
set number
set relativenumber
set noshowmode
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set mousehide
set vb

function! Readonly()
    if &readonly || !&modifiable
	return ' [readonly]'
    else
	return ''
    endif
endfunction

" --- Treesitter Config ---
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
	"c",
	"cpp",
	"python",
	"java",
	"fish",
	"haskell"
    },

    highlight = { 
	enable = true,
        disable = {}
    },
}
EOF

" --- LSP Config ---
" lua << EOF
" require'lspconfig'.clangd.setup{}
" EOF


" --- Color scheme 1 ---
set background=dark
" hi Comment    ctermfg = 39                                  guifg = cyan
" hi Special    ctermfg = 5                                   guifg = purple
" hi PrePoc     ctermfg = 5                                   guifg = purple
" hi Identifier ctermfg = 33                                  guifg = orange
" hi Constant   ctermfg = 166                   cterm = bold  guifg = orange
" hi ErrorMsg   ctermfg = white  ctermbg = red                guifg = white      guibg = red
" hi Normal     ctermfg = 7                                   guifg = white      guibg = #3d3d3d

" hi User1      ctermfg = 154    ctermbg = 22                 guifg = darkgreen  guibg = yellow
" hi User2      ctermfg = 123    ctermbg = 97                 guifg = darkorange guibg = gold
" hi User3      ctermfg = 214    ctermbg = 94                 guifg = gold       guibg = orangered
" hi Over80col  ctermfg = 22     ctermbg = 154                guifg = darkgreen  guibg = yellow
" hi NrmlClr    ctermfg = 15     ctermbg = 8                  guifg = white      guibg = #727272
" hi InrtClr    ctermfg = 15     ctermbg = 28                 guifg = white      guibg = #43d31f
" hi ReplClr    ctermfg = 015    ctermbg = 142                guifg = white      guibg = gold
" hi VisuClr    ctermfg = 015    ctermbg = 61                 guifg = white      guibg = purple

" --- Color Scheme in hex ---
" User1        ctermfg = GreenYellow     (#afff00)   ctermbg = DarkGreen     (#005f00)
" User2        ctermfg = DarkSlateGray1  (#87ffff)   ctermbg = MediumPurple3 (#875faf)
" User3        ctermfg = Orange1         (#ffaf00)   ctermbg = Orange4       (#875f00)
" NrmlClr      ctermfg = White           (#ffffff)   ctermbg = Grey          (#808080)
" InrtClr      ctermfg = White           (#ffffff)   ctermbg = Green4        (#008700)
" ReplClr      ctermfg = White           (#ffffff)   ctermbg = Gold3         (#afaf00)
" VisuClr      ctermfg = White           (#ffffff)   ctermbg = SlateBlue3    (#5f5f87)


" --- Color Scheme 2 ---
hi Comment      ctermfg = 47
hi Special      ctermfg = 87
hi PrePoc       ctermfg = 75
hi Identifier   ctermfg = 112    cterm = NONE
hi Constant     ctermfg = 43
hi ErrorMsg     ctermfg = white  ctermbg = red
hi Error        ctermfg = white  ctermbg = 124
hi Todo         ctermfg = black  ctermbg = 76
" hi Normal       ctermfg = 15     ctermbg = 234
hi Normal       ctermfg = 07
hi Search       ctermfg = 22     ctermbg = 117
hi Statement    ctermfg = 75

hi User1        ctermfg = 15     ctermbg = 68
hi User2        ctermfg = 15     ctermbg = 67
hi Over80col    ctermfg = 22     ctermbg = 38
hi NrmlClr      ctermfg = 15     ctermbg = 67
hi InrtClr      ctermfg = 15     ctermbg = 35
hi ReplClr      ctermfg = 015    ctermbg = 172
hi VisuClr      ctermfg = 015    ctermbg = 61


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
set statusline+=%#User2#
set statusline+=\ %f " Filepath relative to current directory
set statusline+=%{Readonly()}  " Is this file read only
set statusline+=%=  "  Everything after this is now on the right side
set statusline+=%y\ /\  " Adds the file type and a slash
set statusline+=%{&fileencoding?&fileencoding:&encoding}\ 
set statusline+=\ %l/%L\:\%c\  " Adds current line over total number of lines with the column number
set statusline+=\ %p%%\   " Adds the percentage through the document

" --- Shortcuts & Key Mappings ---
function! ToggleNumber()
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

function! TurnOffNumbers()
    set nornu
    set nonu
endfunction

function! ToggleSpell()
  if &spell == 1
    set nospell
  else
    set spell spelllang=en_gb
  endif
endfunction

function! ToggleRedLine()
  if len(getmatches()) > 0
    match
    set cc=0
  else
    match Over80col /\%80v.\+/
    set cc=80
  endif
endfunction

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key, '[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

lua << EOF
function _G.ToggleVenn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
	vim.b.venn_enabled = true
	vim.cmd[[setlocal ve=all]]

	-- draw a line with HJKL
	vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
	vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
	vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
	vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})

	-- Draw a box with f
	vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
	vim.cmd[[setlocal ve=]]
	vim.cmd[[mapclear <buffer>]]
	vim.b.venn_enabled = nil
    end
end
EOF
    

" Press F2 to write
nnoremap <F2> <ESC>:w<CR>

" Press F3 to exit without writing
nnoremap <F3> <ESC>:q<CR>

" Press F4 to write and quit
" nnoremap <F4> <ESC>ZZ

" F5 to toggle spell check
nnoremap <F5> <ESC>:call ToggleSpell()<CR>

" F6 to toggle red line at col 80
nnoremap <F6> <ESC>:call ToggleRedLine()<CR>

" Ctrl + F6 to highlight trailing whitespace
nnoremap <C-F6> <ESC>/\s\+$/<CR>

" Ctrl + F8 and Ctrl + F7 to navigate tabs
nnoremap <F7> <ESC>:tabp<CR>
nnoremap <F8> <ESC>:tabn<CR>

" Press F10 to toggle relative numbers and Ctrl + F6 to turn them off entirely
nnoremap <F10> <ESC>:call ToggleNumber()<CR>
nnoremap <C-F10> <ESC>:call TurnOffNumbers()<CR>

" C-[hjkl] moves and/or splits the buffer
nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

" <leader> [hjkl] resizes the current buffer
nnoremap <leader>h :vertical resize -2<CR>
nnoremap <leader>j :resize -2<CR>
nnoremap <leader>k :resize +2<CR>
nnoremap <leader>l :vertical resize +2<CR>

" <leader>v toggles Venn mode
nnoremap <leader>v :lua ToggleVenn()<CR>

" Telescope keymaps
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fb <cmd>Telescope buffers <CR>

" --- Macros ---
let @u = 'i̲' " Underlining a character
let @e = 'i̅' " Overlining a character
let @o = 'o{}0k' " Curly brackets on the same column
let @a = 'A {}0k[4~'   " Curly brackets on different columns


" Clippy
"  /\
" ◔ |◔
" | ||
"  \/|

" Rulere
" ---------------
" | l l l l l l |
" |_____________|

" Doggo
"   _
"  / \
" |◕ ◕|
" | ᴥ |
"  \_/
