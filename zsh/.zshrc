# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump web-search python golang fzf zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/fzf-git.sh/fzf-git.sh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

export PATH=$HOME/.progate/bin:$PATH
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
eval "$(nodenv init -)"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# opencode
export PATH=/Users/oohashitenshou/.opencode/bin:$PATH

# Added by Antigravity
export PATH="/Users/oohashitenshou/.antigravity/antigravity/bin:$PATH"


# add nvim
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R" 
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# setopt no-beep
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd
setopt hist_ignore_dups
setopt share_history
setopt inc_append_history

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# CLAUDE
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=128000

# --hidden : ドットファイル/隠しファイルも含める 
# --exclude .git : .git ディレクトリを除外（速度改善・ノイズ除去）, 
# --strip-cwd-p# refix : 出力パスを カレント相対に揃える（fzf で見やすい）
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

# fzf 全体の設定: リストを上から表示、カーソルを一番上に
export FZF_DEFAULT_OPTS="--layout=reverse --height 50% --inline-info --bind 'ctrl-f:preview-page-down,ctrl-b:preview-page-up'"

# fzf の代表的キーバインド Ctrl-T（ファイル挿入） が使う列挙コマンドを上の fd … に固定します。
# 結果として、Ctrl-T の候補が fd ベースになります。
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf の Alt-C（ディレクトリへ cd） 用の列挙コマンドを fd --type=d（ディレクトリのみ）にしています。
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# fzf completion preview customization (zsh)
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview 'eza --tree --color=always {} | head -200' "$@"
      ;;
    export|unset)
      fzf --preview 'eval "echo \${}"' "$@"
      ;;
    ssh)
      fzf --preview 'dig {}' "$@"
      ;;
    *)
      fzf --preview 'bat -n --color=always --line-range :500 {}' "$@"
      ;;
  esac
}

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always --line-range :500 {}'
  --preview-window 'right:60%:wrap'
  --bind 'ctrl-f:preview-page-down,ctrl-b:preview-page-up'
  --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'
  --bind 'alt-up:preview-up,alt-down:preview-down'
"

export BAT_THEME="tokyonight_night"
alias lsc='eza --color=auto --color-scale'
alias lsgit='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --tree --level=3'
alias lsgitsf="git status --porcelain | fzf"
alias cd="z"

eval $(thefuck --alias)
eval $(thefuck --alias fk)
eval "$(zoxide init zsh)"

# ========================================
# Git エイリアス
# ========================================
alias gs='git status'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git switch'
alias gc='git commit -v'
alias gca='git commit -v --amend'
alias gp='git push'
alias gpf='git push --force'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add .'
alias gf='git fetch'
alias gpl='git pull'
alias gm='git merge'
alias gr='git rebase'
alias grs='git reset'
alias grsh='git reset --hard'
alias gcl='git clone'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstp='git stash pop'
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=100000

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$PATH:$(npm config get prefix)/bin"
