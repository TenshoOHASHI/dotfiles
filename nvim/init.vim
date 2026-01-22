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

" バッファのディレクトリを自動的にカレントディレクトリにする
set autochdir

" Vim起動時にカレントディレクトリを維持
autocmd VimEnter * if expand('%') == '' | cd $PWD | endif

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
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Markdownプレビュー
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

call plug#end()

" =========================
" 見た目
" =========================
set termguicolors
set background=dark
let g:tokyonight_style = "night"   " night / storm / moon / day
colorscheme tokyonight

" colorscheme horizon

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

" 新規ノート作成
nnoremap <silent> <leader>onn :ObsidianNew
nnoremap <silent> <leader>onq :ObsidianQuickNew<CR>

" デイリーノート
nnoremap <silent> <leader>od :ObsidianToday<CR>
nnoremap <silent> <leader>oy :ObsidianYesterday<CR>
nnoremap <leader>om :ObsidianTomorrow<CR>

" 画像貼り付け
nnoremap <silent> <leader>oi :ObsidianPasteImg

" テンプレート
nnoremap <silent> <leader>otmpl :ObsidianTemplate

" Markdownプレビュー
nnoremap <silent> <leader>op :MarkdownPreview<CR>
nnoremap <silent> <leader>ops :MarkdownPreviewStop<CR>
nnoremap <silent> <leader>opt :MarkdownPreviewToggle<CR>

" Markdownプレビューの設定
" ブラウザを自動で閉じない（0:閉じない, 1:閉じる）
" 別のファイルを開いたときに自動的にプレビューを切り替えたい場合は1にしてください
let g:mkdp_auto_close = 1

" 以下の設定は問題が発生する場合、コメントアウトしてください
" " Node.jsのパス設定（nodenvの場合）
" let g:mkdp_markdown_css = ''
" let g:mkdp_highlight_css = ''
" let g:mkdp_port = ''
" let g:mkdp_page_title = '「${name}」'
"
" " Node.jsのパスを明示的に指定
" let g:mkdp_echo_preview_url = 1
" let g:mkdp_browser = ''
" let g:mkdp_open_ip = ''

" ========================================
" Wikiリンクの強調表示と移動機能
" ========================================

" WikiリンクとMarkdownリンクのハイライト
augroup WikiLinkHighlight
  autocmd!
  autocmd FileType markdown syntax match WikiLink /\[\{2}[^\]]*\]\{2}/ containedin=ALL
  autocmd FileType markdown syntax match MDLink /\[[^\]]*\]([^\)]*)/ containedin=ALL
  autocmd FileType markdown highlight link WikiLink Underlined
  autocmd FileType markdown highlight link MDLink Underlined
augroup END

" 次のリンク（WikiリンクまたはMarkdownリンク）にジャンプ
nnoremap <silent> <leader>ln :<C-U>call <SID>jump_to_next_link()<CR>

" 前のリンク（WikiリンクまたはMarkdownリンク）にジャンプ
nnoremap <silent> <leader>lp :<C-U>call <SID>jump_to_prev_link()<CR>

" ファイル内のすべてのリンクを一覧表示
nnoremap <silent> <leader>ll :<C-U>call <SID>list_links_on_line()<CR>

" ========================================
" カーソル下の単語をWikiリンクに変換（自動化）
" ========================================
nnoremap <silent> <leader>olw :<C-U>call WrapWordInWikiLink()<CR>

" ========================================
" リンク関連の関数
" ========================================

" 次のリンク（WikiリンクまたはMarkdownリンク）にジャンプする関数
function! s:jump_to_next_link()
  let l:current_line = line('.')
  let l:current_col = col('.')

  " 現在の位置から後ろを検索
  let l:line = l:current_line
  while l:line <= line('$')
    if l:line == l:current_line
      let l:content = getline('.')
      let l:start_col = l:current_col
    else
      let l:content = getline(l:line)
      let l:start_col = 1
    endif

    " WikiリンクまたはMarkdownリンクを検索
    let l:wiki_pattern = '\[\{2}[^\]]*\]\{2}'
    let l:md_pattern = '\[[^\]]*\]([^\)]*)'

    " 両方のパターンで検索し、最も近いものを選択
    let l:wiki_match = match(l:content, l:wiki_pattern, l:start_col - 1)
    let l:md_match = match(l:content, l:md_pattern, l:start_col - 1)

    " より手前のマッチを選択
    let l:best_match = -1
    if l:wiki_match != -1 && l:md_match != -1
      let l:best_match = (l:wiki_match < l:md_match) ? l:wiki_match : l:md_match
    elseif l:wiki_match != -1
      let l:best_match = l:wiki_match
    elseif l:md_match != -1
      let l:best_match = l:md_match
    endif

    if l:best_match != -1
      " リンクが見つかったらジャンプ
      call cursor(l:line, l:best_match + 1)
      return
    endif

    let l:line += 1
  endwhile

  echo "リンクが見つかりませんでした"
endfunction

" 前のリンク（WikiリンクまたはMarkdownリンク）にジャンプする関数
function! s:jump_to_prev_link()
  let l:current_line = line('.')
  let l:current_col = col('.')

  " 現在の位置から前を検索
  let l:line = l:current_line
  while l:line >= 1
    if l:line == l:current_line
      let l:content = getline('.')
      let l:end_col = l:current_col - 1
    else
      let l:content = getline(l:line)
      let l:end_col = strlen(l:content)
    endif

    " WikiリンクとMarkdownリンクを検索（後ろから）
    let l:wiki_pattern = '\[\{2}[^\]]*\]\{2}'
    let l:md_pattern = '\[[^\]]*\]([^\)]*)'

    " 両方のパターンで最後のマッチを探す
    let l:last_match = -1

    " Wikiリンクの最後のマッチ
    let l:wiki_match = match(l:content, l:wiki_pattern)
    while l:wiki_match != -1 && l:wiki_match < l:end_col
      let l:last_match = l:wiki_match
      let l:wiki_match = match(l:content, l:wiki_pattern, l:wiki_match + 1)
    endwhile

    " Markdownリンクの最後のマッチ
    let l:md_match = match(l:content, l:md_pattern)
    let l:md_last = -1
    while l:md_match != -1 && l:md_match < l:end_col
      let l:md_last = l:md_match
      let l:md_match = match(l:content, l:md_pattern, l:md_match + 1)
    endwhile

    " より後ろのマッチを選択
    if l:last_match != -1 && l:md_last != -1
      let l:last_match = (l:last_match > l:md_last) ? l:last_match : l:md_last
    elseif l:md_last != -1
      let l:last_match = l:md_last
    endif

    if l:last_match != -1
      " リンクが見つかったらジャンプ
      call cursor(l:line, l:last_match + 1)
      return
    endif

    let l:line -= 1
  endwhile

  echo "リンクが見つかりませんでした"
endfunction

" ファイル内のすべてのリンクを一覧表示する関数
function! s:list_links_on_line()
  let l:wiki_pattern = '\[\{2}[^\]]*\]\{2}'
  let l:md_pattern = '\[[^\]]*\]([^\)]*)'
  let l:links = []

  " ファイル全体をスキャン
  let l:line_num = 1
  while l:line_num <= line('$')
    let l:content = getline(l:line_num)

    " Wikiリンクを検索
    let l:match = match(l:content, l:wiki_pattern)
    while l:match != -1
      let l:link_text = matchstr(l:content, l:wiki_pattern, l:match)
      call add(l:links, {'line': l:line_num, 'col': l:match + 1, 'text': l:link_text, 'type': 'Wiki'})
      let l:match = match(l:content, l:wiki_pattern, l:match + strlen(l:link_text))
    endwhile

    " Markdownリンクを検索
    let l:match = match(l:content, l:md_pattern)
    while l:match != -1
      let l:link_text = matchstr(l:content, l:md_pattern, l:match)
      call add(l:links, {'line': l:line_num, 'col': l:match + 1, 'text': l:link_text, 'type': 'MD'})
      let l:match = match(l:content, l:md_pattern, l:match + strlen(l:link_text))
    endwhile

    let l:line_num += 1
  endwhile

  if len(l:links) == 0
    echo "このファイルにはリンクがありません"
  else
    echo "リンク一覧（合計 " . len(l:links) . " 件）:"
    echo "==========================================="
    for i in range(len(l:links))
      let l:link = l:links[i]
      echo string(i + 1) . '. [' . l:link['type'] . '] 行' . l:link['line'] . ': ' . l:link['text']
    endfor
    echo "==========================================="
    echo "ヒント: ',ln' で次のリンクへ、',lp' で前のリンクへ"
  endif
endfunction

" ========================================
" カーソル下の単語をWikiリンクに変換（自動化）
" ========================================
nnoremap <silent> <leader>olw :<C-U>call WrapWordInWikiLink()<CR>

" カーソル下の単語から新規ノートを作成してリンク
nnoremap <silent> <leader>oln :<C-U>call CreateNoteFromWord()<CR>

" 戻る（直前のバッファへ）
nnoremap <silent> <leader>bp :b#<CR>

" ========================================
" Git (vim-fugitive)
" ========================================
" Ctrl-G プレフィックス（fugitiveのデフォルト機能）
"   Ctrl-G Ctrl-F: ファイル一覧
"   Ctrl-G Ctrl-B: ブランチ一覧（ローカル & リモート）
"   Ctrl-G Ctrl-T: タグ一覧
"   Ctrl-G Ctrl-R: リモート一覧
"   Ctrl-G Ctrl-H: コミットハッシュ一覧
"   Ctrl-G Ctrl-S: スタッシュ一覧
"   Ctrl-G Ctrl-L: reflog一覧
"   Ctrl-G Ctrl-W: worktree一覧
"   Ctrl-G Ctrl-E: git for-each-ref

" LeaderキーでのGit操作
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gs :G<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gp :Gpush<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gB :GBranches<CR>
nnoremap <silent> <leader>gm :Git switch

" ========================================
" Git Gutter
" ========================================
nnoremap <silent> <leader>ghn :GitGutterLineHighlightsDisable<CR>
nnoremap <silent> <leader>ght :GitGutterLineHighlightsToggle<CR>
nnoremap <silent> <leader>ghp :GitGutterPreviewHunk<CR>
nnoremap <silent> <leader>ghs :GitGutterStageHunk<CR>
nnoremap <silent> <leader>ghu :GitGutterUndoHunk<CR>

" 設定再読み込み
nnoremap <silent> <leader><leader> :source $MYVIMRC<CR>

" markdown のときだけ conceallevel を確実に 2 にする（保険）
augroup ObsidianMarkdown
  autocmd!
  " conceallevel=1 にすることで、Wikiリンク [[...]] が表示される
  autocmd FileType markdown setlocal conceallevel=1
augroup END

" カレントディレクトリを自動的にバッファのディレクトリにする
augroup AutoLCD
  autocmd!
  " BufEnter: バッファに入ったとき
  " WinEnter: ウィンドウに入ったとき
  autocmd BufEnter * silent! lcd %:p:h
  autocmd WinEnter * silent! lcd %:p:h
augroup END

" ========================================
" 自動化関数
" ========================================

" カーソル下の単語をWikiリンクで囲む
function! WrapWordInWikiLink()
  " カーソル位置の単語を取得
  let l:word = expand('<cword>')

  " 単語が空の場合は処理しない
  if empty(l:word)
    echo "カーソル下に単語がありません"
    return
  endif

  " 単語の開始・終了位置を取得
  let l:line = getline('.')
  let l:col = col('.')
  let l:start = col('.') - 1
  let l:end = col('.')

  " 単語の境界を見つける
  while l:start > 0 && l:line[l:start - 1] =~# '[a-zA-Z0-9一-龥ぁ-んァ-ヴー]'
    let l:start -= 1
  endwhile
  while l:end <= len(l:line) && l:line[l:end - 1] =~# '[a-zA-Z0-9一-龥ぁ-んァ-ヴー]'
    let l:end += 1
  endwhile

  " 単語をWikiリンクで置換
  let l:new_line = l:line[:l:start-1] . '[[' . l:word . ']]' . l:line[l:end-1:]
  call setline('.', l:new_line)
endfunction

" カーソル下の単語から新規ノートを作成してリンク
function! CreateNoteFromWord()
  " カーソル位置の単語を取得
  let l:word = expand('<cword>')

  " 単語が空の場合は処理しない
  if empty(l:word)
    echo "カーソル下に単語がありません"
    return
  endif

  " 新規ノート作成コマンドを実行
  execute 'ObsidianNew ' . l:word
endfunction

