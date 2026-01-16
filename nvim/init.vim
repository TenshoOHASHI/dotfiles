" =========================
" 基本
set shell=/bin/zsh
set shiftwidth=4
set tabstop=4
set expandtab
set textwidth=0
set autoindent
set hlsearch
set clipboard=unnamed
syntax on
filetype plugin indent on

" Leader は “マッピング定義より前” に置く
let mapleader = ","

" markdown 表示用（obsidian.nvim のUI警告を避ける）
" 必要なら markdown のときだけ上書きするので、まずは全体で2にしておく
set conceallevel=2

" =========================
" プラグイン管理（vim-plug）
" =========================
call plug#begin()

Plug 'ntk148v/vim-horizon'
Plug 'preservim/nerdtree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" obsidian.nvim 依存
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'epwalsh/obsidian.nvim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

call plug#end()

" =========================
" 見た目
" =========================
set termguicolors
colorscheme horizon

" gitgutter 
let g:lightline = {}
let g:lightline.colorscheme = 'horizon'

augroup MyGitGutterHighlights
  autocmd!
  autocmd ColorScheme * highlight GitGutterAdd      guifg=#7fdc7f gui=bold
  autocmd ColorScheme * highlight GitGutterChange   guifg=#ffd27f gui=bold
  autocmd ColorScheme * highlight GitGutterDelete   guifg=#ff7f7f gui=bold

  " 行背景が使える場合（配色・設定によって効きます）
  autocmd ColorScheme * highlight GitGutterAddLine    guibg=#1f3a1f
  autocmd ColorScheme * highlight GitGutterChangeLine guibg=#3a2f1f
  autocmd ColorScheme * highlight GitGutterDeleteLine guibg=#3a1f1f
augroup END

let g:gitgutter_highlight_lines = 1

" =========================
" NERDTree
" =========================
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>E :NERDTreeFind<CR>

" =========================
" Obsidian.nvim（Lua 側の設定を読む）
" =========================
lua require('obsidian_setup')

" =========================
" Obsidian: あなた用のショートカット（コマンド呼び出し）
" =========================
" Link（Visual 選択が前提）
xnoremap <silent> <leader>ol :<C-U>ObsidianLink<CR>
xnoremap <silent> <leader>oL :<C-U>ObsidianLinkNew<CR>

" Navigate / search
nnoremap <silent> <leader>oo :ObsidianOpen<CR>
nnoremap <silent> <leader>of :ObsidianFollowLink<CR>
nnoremap <silent> <leader>ob :ObsidianBacklinks<CR>
nnoremap <silent> <leader>oq :ObsidianQuickSwitch<CR>
nnoremap <silent> <leader>os :ObsidianSearch<CR>
nnoremap <silent> <leader>ot :ObsidianTags<CR>
nnoremap <silent> <leader>ow :ObsidianWorkspace<CR>

" 戻る（直前のバッファへ）
nnoremap <silent> <leader>bp :b#<CR>

" 設定再読み込み
nnoremap <silent> <leader><leader> :source $MYVIMRC<CR>

" markdown のときだけ conceallevel を確実に 2 にする（保険）
augroup ObsidianMarkdown
  autocmd!
  autocmd FileType markdown setlocal conceallevel=2
augroup END

