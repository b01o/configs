" theme configuration

filetype plugin indent on
syntax on

set nu rnu

set linebreak
set showbreak=……

set shiftwidth=2
set autoindent
set smartindent

set mouse=a
set clipboard=unnamed
set guifont=Iosevka:h18,PingFang\ SC:h18
set laststatus=2
set noshowmode
set backspace=indent,eol,start
" set colorcolumn=80
set hidden


set undofile				" Save undos after file closes
set undodir=$HOME/.config/nvim/undo	" where to save undo histories
set undolevels=100000			" How many undos
set undoreload=100000			" number of lines to save for undo

" set incsearch
set hlsearch
set scrolloff=2

" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

set lazyredraw

let rtp=&runtimepath
set runtimepath=~/.config/nvim
let &runtimepath.=','.rtp.',~/.config/vim/after'

if !has('nvim')
  set viminfo+=n~/.config/vim/viminfo
endif

if has('nvim')
  " Avoid showing extra messages when using completion
  " set shortmess+=c

  set completeopt=menuone,noinsert,noselect
endif

" config for VimR
" if has("gui_vimr")
" endif

set nocompatible
if (has("termguicolors"))
  set termguicolors
endif
filetype off

set rtp+=~/dev/others/base16/templates/vim/
call plug#begin()

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  " rust environment
  Plug 'simrat39/rust-tools.nvim'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/vim-vsnip-integ'

  " cmp Snippet completion
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'nvim-lua/lsp_extensions.nvim'

  " cmp Path completion
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'

  " Snippet engine
  Plug 'hrsh7th/vim-vsnip'

  " Optional
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'folke/lsp-colors.nvim'
endif

" UI improvement
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/goyo.vim'
Plug 'wfxr/minimap.vim'
Plug 'ap/vim-css-color'
Plug 'lukas-reineke/indent-blankline.nvim'

" Colors
Plug 'wadackel/vim-dogrun'
Plug 'arcticicestudio/nord-vim'
Plug 'AlessandroYorba/Alduin'

" syntactic support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'Chiel92/vim-autoformat'
Plug 'plasticboy/vim-markdown'
" Plug 'narodnik/rust-fold-functions.vim'

Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-rooter'
call plug#end()


" =====================
" Color setup
" =====================
" set t_CO=256
set background=dark
colorscheme dogrun
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE

highlight Visual guifg=#785e26 guibg=#fabd2f gui=none
highlight IncSearch guifg=#785e26 guibg=#fabd2f gui=none
highlight Search guifg=#785e26 guibg=#fabd2f gui=none
highlight HighlightedyankRegion guifg=#785e26 guibg=#fabd2f

" highlight MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#494949
" let g:minimap_highlight = 'MinimapCurrentLine'
" ========================
" Color setup end
" ========================


" let g:coq_settings = { 'display.icons.mode': 'none', 'auto_start': 'shut-up', 'display.pum.fast_close': v:false }

let g:autoformat_autoindent = 0
let g:minimap_width = 12
let g:minimap_auto_start = 0
let g:minimap_auto_start_win_enter = 0
let g:minimap_highlight_range = 1
let g:minimap_highlight_search = 1
" dont show banner
let g:netrw_banner = 0
let g:matchup_matchparen_offscreen = {'method': 'popup'}
"
" preview window is shown in vertically split window
let g:netrw_preview = 1
let g:netrw_winsize = 25

" " LSP configuration
" lua << END
" require('rust-tools').setup({})

" END

let mapleader=" "
if has('nvim')
  lua require('setup-lsp')

  " Code navigation shortcuts
  " as found in :help lsp
  nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <Leader>t :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }<CR>
  nnoremap <Leader>T :lua require'lsp_extensions'.inlay_hints()<CR>

  " Quick-fix
  nnoremap <silent> <Leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <Leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> <Leader>f    <cmd>lua vim.lsp.buf.formatting()<CR>

  nnoremap <silent> <Leader>e   <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nnoremap <silent> <Leader>q   <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
  lua require('setup-completion')


  " 300ms of no cursor movement to trigger CursorHold
  set updatetime=300

  " Goto previous/next diagnostic warning/error
  nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
endif

let g:vsnip_filetypes = {}

let mapleader=" "

" Keystroke Remaps
nnoremap <silent> <S-F4> :Autoformat<CR>
nmap <silent> <F5> [%zf%
nmap <silent> <S-F5> [%j0 zf]%
nnoremap <silent> <F4> :Goyo<CR>
nnoremap <silent> <F2> :set wrap!<CR>
nmap <F3> i<C-R>=strftime("%b %d %Y %Z")<CR><Esc>
imap <F3> <C-R>=strftime("%b %d %Y %Z")<CR>
nnoremap <silent> <F8> :set rnu!<CR>
nnoremap <silent> <S-F8> :set nu!<CR>
nnoremap <silent> <leader><leader> <C-^>

" matchup
nnoremap <c-i> :<c-u>MatchupWhereAmI?<cr>

" delete without yanking
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d
cnoremap <silent> <leader>d "_d

" cancel highlight
nnoremap <silent> <leader>n :nohl<CR>

" mapping esc
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>

" disable ex mode
noremap Q <Nop>

" For simple sizing of splits.
nnoremap - <C-W>-
nnoremap + <C-W>+

" Launch fzf with CTRL+P.
nnoremap <silent> <C-p> :FZF -m<CR>

" Map a few common things to do with FZF.
nnoremap <silent> <Leader><Enter> :Buffers<CR>
nnoremap <silent> <Leader>l :Lines<CR>

nnoremap <silent> <Leader>va vGoggV

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <Leader>r :%s///g<Left><Left>
nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <Leader>r :s///g<Left><Left>
xnoremap <Leader>rc :s///gc<Left><Left><Left>

" quick replacement"
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" set ignorecase
" assumes set ignorecase smartcase
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter : set ignorecase
  autocmd CmdLineLeave : set noignorecase
augroup END

command W write

" supporting format on saving
autocmd BufWrite * :Autoformat
