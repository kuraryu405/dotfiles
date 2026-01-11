# ~/.dotfiles/zsh/.zshrc
#
# このファイルは Zsh の基本設定用テンプレートです。
# 好みに合わせて少しずつ編集して使ってください。

########################################
# 基本設定
########################################

# ヒストリ設定
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt HIST_IGNORE_DUPS       # 同じコマンドを連続して記録しない
setopt HIST_IGNORE_SPACE      # 先頭がスペースのコマンドを記録しない
setopt SHARE_HISTORY          # 複数シェル間でヒストリ共有

# 補完機能
autoload -Uz compinit
compinit

setopt AUTO_CD                # ただパスを打つだけで cd
setopt CORRECT                # コマンドのスペルミスを補正
setopt AUTO_LIST              # 補完候補を自動表示
setopt COMPLETE_IN_WORD

########################################
# プロンプト
########################################

autoload -Uz colors && colors

PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# '

########################################
# PATH / 環境変数
########################################

export EDITOR=vim
export PAGER=less

# よく使うパスをここに追加
path=(
  $HOME/.local/bin
  $path
)

########################################
# エイリアス
########################################

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias gc='git commit'
alias gl='git log --oneline --graph --decorate'

########################################
# プラグイン / 追加設定読み込み
########################################

# ここにプラグインマネージャや追加設定を追記してください。
# 例:
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

