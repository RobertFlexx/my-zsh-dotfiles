export ZDOTDIR="$HOME"
export EDITOR="nano"
export VISUAL="nano"
export PAGER="less"
export LESS="-R"
export LANG="en_US.UTF-8"
export CLICOLOR=1

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt AUTO_LIST
setopt GLOB_DOTS
setopt PROMPT_SUBST

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

autoload -Uz compinit
autoload -Uz colors
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

colors
compinit

zmodload zsh/complist
zmodload zsh/zle
zmodload zsh/system

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{111}-- %d --%f'
zstyle ':completion:*:messages' format '%F{180}%d%f'
zstyle ':completion:*:warnings' format '%F{203}no matches found%f'
zstyle ':completion:*:corrections' format '%F{150}%d (errors: %e)%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{114}●%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{214}●%f'
zstyle ':vcs_info:git:*' formats ' %F{141}git%f:%F{117}%b%f %c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{141}git%f:%F{117}%b%f %F{203}(%a)%f %c%u'

bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^R' history-incremental-search-backward

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

if [[ -z "$LS_COLORS" ]]; then
  export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34'
fi

alias ls='ls --color=auto -F'
alias ll='ls --color=auto -lh'
alias la='ls --color=auto -A'
alias l='ls --color=auto -lah'
alias lt='ls --color=auto -lahtr'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias cls='clear'
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'
alias h='fc -l 1'
alias path='printf "%s\n" ${path}'
alias now='date "+%Y-%m-%d %H:%M:%S"'

alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gs='git status -sb'
alias gl='git log --oneline --decorate --graph --all'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gr='git restore'
alias grs='git restore --staged'

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) unxz "$1" ;;
    *.zst) unzstd "$1" ;;
    *) printf 'cannot extract: %s\n' "$1" ;;
  esac
}

git_branch_count() {
  local count
  count=$(git rev-list --count --all 2>/dev/null) || return
  printf '%s' "$count"
}

git_ahead_behind() {
  local ahead behind
  local upstream
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || return
  ahead=$(git rev-list --count "${upstream}..HEAD" 2>/dev/null)
  behind=$(git rev-list --count "HEAD..${upstream}" 2>/dev/null)
  [[ "$ahead" != 0 ]] && printf ' %F{48}↑%s%f' "$ahead"
  [[ "$behind" != 0 ]] && printf ' %F{203}↓%s%f' "$behind"
}

prompt_git_extra() {
  local extra
  extra="$(git_ahead_behind)"
  [[ -n "$extra" ]] && printf '%s' "$extra"
}

set_title() {
  print -Pn "\e]0;%n@%m: %~\a"
}

build_prompt() {
  local exit_part user_part host_part path_part time_part git_part symbol_part
  local jobs_part

  if [[ $? -eq 0 ]]; then
    exit_part="%F{78}✔%f"
  else
    exit_part="%F{203}✘%f"
  fi

  user_part="%F{81}%n%f"
  host_part="%F{110}%m%f"
  path_part="%F{150}%~%f"
  time_part="%F{245}%*%f"
  jobs_part='%(1j.%F{214}jobs:%j%f .)'

  vcs_info
  git_part="${vcs_info_msg_0_}$(prompt_git_extra)"

  PROMPT="${exit_part} %B${user_part}%b %F{245}at%f ${host_part} %F{245}in%f ${path_part}${git_part}
%B%F{219}❯%f%b "
  RPROMPT="${jobs_part}${time_part:+ ${time_part}}"
}

add-zsh-hook precmd set_title
add-zsh-hook precmd build_prompt

if [[ -f /etc/zshrc ]]; then
  source /etc/zshrc
fi
