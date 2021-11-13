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
set guifont=Iosevka:h16,PingFang\ SC:26
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

set nocompatible
if (has("termguicolors"))
  set termguicolors
endif
filetype off

set rtp+=~/dev/others/base16/templates/vim/
call plug#begin()

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp_extensions.nvim'
  " the main coq
  Plug 'ms-jpq/coq_nvim',  {'branch': 'coq'}
  " 9000+ Snippets
  Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
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

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

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
highlight HighlightedyankRegion guifg=#785e26 guibg=#fabd2f

" highlight MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#494949
" let g:minimap_highlight = 'MinimapCurrentLine'
" ========================
" Color setup end
" ========================


let g:coq_settings = { 'display.icons.mode': 'none', 'auto_start': 'shut-up', 'display.pum.fast_close': v:false }

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

" LSP configuration
lua << END
local lspconfig = require('lspconfig')
local coq = require "coq"
local on_attach = function(client, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--Enable completion triggered by <c-x><c-o>
buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

local servers = { "rust_analyzer" , "pyright"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup( coq.lsp_ensure_capabilities( {
      on_attach = on_attach,
      flags = {
	debounce_text_changes = 150,
      },
      settings = {
	  ['rust-analyzer'] = {
	      checkOnSave = {
		  allFeatures = true,
		  overrideCommand = {
		      'cargo', 'clippy', '--workspace', '--message-format=json',
		      '--all-targets', '--all-features'
		  }
	      }
	  }
      }

  }))
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
END


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
