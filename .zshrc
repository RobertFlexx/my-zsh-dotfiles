export ZDOTDIR="${ZDOTDIR:-$HOME}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_CONFIG_HOME/zsh" "$XDG_DATA_HOME/zsh" "$XDG_STATE_HOME/zsh"

if (( $+commands[nvim] )); then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif (( $+commands[vim] )); then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="nano"
  export VISUAL="nano"
fi

export PAGER="less"
export LESS="-R -F -X -i"
export LESSHISTFILE=-
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-}"
export CLICOLOR=1
export COLORTERM=truecolor
export MANPAGER="less -R"
export GPG_TTY="$(tty 2>/dev/null)"
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

umask 022

typeset -U path fpath cdpath manpath

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/share/gem/ruby/bin"
  $path
)

cdpath=(
  "$HOME"
  "$HOME/projects"
  "$HOME/src"
  "$HOME/code"
  $cdpath
)

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt CDABLE_VARS
setopt AUTO_PARAM_SLASH
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
setopt NO_BEEP
setopt NO_FLOW_CONTROL
setopt NO_HUP
setopt NO_NOMATCH
setopt NO_NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PIPE_FAIL
setopt PROMPT_SUBST
setopt RC_EXPAND_PARAM
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt GLOB_DOTS
setopt MULTIOS
setopt COMPLETE_ALIASES

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=200000
SAVEHIST=200000

autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit
autoload -Uz down-line-or-beginning-search
autoload -Uz edit-command-line
autoload -Uz select-word-style
autoload -Uz up-line-or-beginning-search
autoload -Uz vcs_info

colors
select-word-style shell

zmodload zsh/complist
zmodload zsh/datetime
zmodload zsh/stat
zmodload zsh/system
zmodload zsh/zle

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate _ignored _match _prefix _history
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' group-name ''
zstyle ':completion:*' keep-prefix true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt '%S%M matches%s'
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%F{111}-- %d --%f'
zstyle ':completion:*:messages' format '%F{180}%d%f'
zstyle ':completion:*:warnings' format '%F{203}no matches found%f'
zstyle ':completion:*:corrections' format '%F{150}%d (errors: %e)%f'
zstyle ':completion:*:approximate:*' max-errors 2 numeric
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,%mem,etime,comm -w -w'
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:(ssh|scp|sftp|rsync):*' hosts off
zstyle ':completion:*' users off

if [[ -z "$LS_COLORS" ]]; then
  export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34'
fi

if (( $+commands[dircolors] )); then
  eval "$(dircolors -b 2>/dev/null)"
fi

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' %F{111}[%b%c%u]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{111}[%b|%a%c%u]%f'

_zcompdump="$XDG_CACHE_HOME/zsh/.zcompdump-$HOST-$ZSH_VERSION"
compinit -i -d "$_zcompdump"

bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' forward-char
bindkey '^B' backward-char
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^W' backward-kill-word
bindkey '^Y' yank
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^X^E' edit-command-line

[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]} ]] && bindkey "${terminfo[kend]}" end-of-line
[[ -n ${terminfo[kdch1]} ]] && bindkey "${terminfo[kdch1]}" delete-char
[[ -n ${terminfo[kcuu1]} ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n ${terminfo[kcud1]} ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
[[ -n ${terminfo[kcub1]} ]] && bindkey "${terminfo[kcub1]}" backward-char
[[ -n ${terminfo[kcuf1]} ]] && bindkey "${terminfo[kcuf1]}" forward-char

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

command_exists() {
  (( $+commands[$1] ))
}

pathprepend() {
  [[ -n "$1" && -d "$1" ]] || return 1
  path=("$1" $path)
}

pathappend() {
  [[ -n "$1" && -d "$1" ]] || return 1
  path+=("$1")
}

pathshow() {
  printf '%s\n' $path
}

reload() {
  source "$ZDOTDIR/.zshrc"
}

mkcd() {
  [[ -n "$1" ]] || return 1
  mkdir -p -- "$1" && cd -- "$1"
}

take() {
  [[ -n "$1" ]] || return 1
  mkdir -p -- "$1" && cd -- "$1"
}

up() {
  local n="${1:-1}"
  local d=''
  while (( n > 0 )); do
    d+='../'
    (( n-- ))
  done
  cd "$d"
}

bak() {
  [[ -e "$1" ]] || return 1
  local ts
  ts=$(date '+%Y%m%d-%H%M%S')
  cp -a -- "$1" "$1.$ts.bak"
}

extract() {
  (( $# > 0 )) || return 1
  local file
  for file in "$@"; do
    [[ -f "$file" ]] || { printf 'not a file: %s\n' "$file" >&2; continue; }
    case "$file" in
      *.tar.bz2|*.tbz2) tar xjf -- "$file" ;;
      *.tar.gz|*.tgz) tar xzf -- "$file" ;;
      *.tar.xz) tar xJf -- "$file" ;;
      *.tar.zst|*.tzst) tar --zstd -xf -- "$file" ;;
      *.tar) tar xf -- "$file" ;;
      *.bz2) bunzip2 -- "$file" ;;
      *.gz) gunzip -- "$file" ;;
      *.xz) unxz -- "$file" ;;
      *.zst) unzstd -- "$file" ;;
      *.zip) unzip -- "$file" ;;
      *.rar) unrar x -- "$file" ;;
      *.7z) 7z x -- "$file" ;;
      *) printf 'cannot extract: %s\n' "$file" >&2 ;;
    esac
  done
}

cdf() {
  local dir
  if command_exists fd && command_exists fzf; then
    dir=$(fd --type d --hidden --follow --exclude .git . "${1:-.}" 2>/dev/null | fzf --height 40% --reverse --border) || return
  elif command_exists fzf; then
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --height 40% --reverse --border) || return
  else
    return 1
  fi
  [[ -n "$dir" ]] && cd -- "$dir"
}

cfile() {
  local file
  if command_exists fd && command_exists fzf; then
    file=$(fd --type f --hidden --follow --exclude .git . "${1:-.}" 2>/dev/null | fzf --height 40% --reverse --border) || return
  elif command_exists fzf; then
    file=$(find "${1:-.}" -type f 2>/dev/null | fzf --height 40% --reverse --border) || return
  else
    return 1
  fi
  [[ -n "$file" ]] && "$EDITOR" -- "$file"
}

fh() {
  command_exists fzf || return 1
  local selected
  selected=$(
    fc -rl 1 |
      awk '!seen[$0]++' |
      fzf --height 45% --reverse --border --tiebreak=index
  ) || return
  LBUFFER="${selected#*[[:space:]]}"
}

zle -N fh
bindkey '^T' fh

fkill() {
  command_exists fzf || return 1
  local pid
  pid=$(
    ps -u "$USER" -o pid=,comm=,etime=,%cpu=,%mem= |
      fzf --height 45% --reverse --border |
      awk '{print $1}'
  ) || return
  [[ -n "$pid" ]] && kill -TERM "$pid"
}

ffind() {
  if command_exists ff; then
    ff "$@"
  elif command_exists fd; then
    fd "$@"
  else
    find . -iname "*${*}*"
  fi
}

groot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  cd "$root"
}

gcleanmerged() {
  git branch --merged 2>/dev/null | grep -vE '^\*|main|master|dev|develop|trunk$' | xargs -r git branch -d
}

git_ahead_behind() {
  local upstream ahead behind
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || return
  ahead=$(git rev-list --count "${upstream}..HEAD" 2>/dev/null)
  behind=$(git rev-list --count "HEAD..${upstream}" 2>/dev/null)
  (( ahead > 0 )) && printf ' %F{48}ahead:%s%f' "$ahead"
  (( behind > 0 )) && printf ' %F{203}behind:%s%f' "$behind"
}

git_stash_count() {
  local count
  count=$(git stash list 2>/dev/null | wc -l | tr -d ' ') || return
  (( count > 0 )) && printf ' %F{179}stash:%s%f' "$count"
}

prompt_git_extra() {
  local extra
  extra="$(git_ahead_behind)$(git_stash_count)"
  [[ -n "$extra" ]] && print -nr -- "$extra"
}

set_title() {
  print -Pn "\e]0;%n@%m: %~\a"
}

typeset -gF __cmd_start=0
typeset -g __cmd_elapsed=""

prompt_preexec() {
  __cmd_start=$EPOCHREALTIME
}

build_prompt() {
  local last_status="$1"
  local status_part user_part host_part path_part git_part prompt_char
  local -a rparts

  if (( last_status == 0 )); then
    status_part="%F{78}ok%f"
  else
    status_part="%F{203}${last_status}%f"
  fi

  user_part="%F{81}%n%f"
  host_part="%F{110}%m%f"
  path_part="%F{150}%~%f"
  git_part="${vcs_info_msg_0_}$(prompt_git_extra)"

  if (( EUID == 0 )); then
    prompt_char='#'
  else
    prompt_char='>'
  fi

  [[ -n "$__cmd_elapsed" ]] && rparts+=("%F{244}${__cmd_elapsed}%f")
  (( ${#jobstates} > 0 )) && rparts+=("%F{214}jobs:${#jobstates}%f")
  rparts+=("%F{245}%*%f")

  PROMPT="%B${user_part}%b@${host_part} ${path_part}${git_part}
${status_part} ${prompt_char} "
  RPROMPT="${(j: :)rparts}"
}

prompt_precmd() {
  local last_status=$?
  local elapsed

  if (( __cmd_start > 0 )); then
    elapsed=$(( EPOCHREALTIME - __cmd_start ))
    if (( elapsed >= 2 )); then
      __cmd_elapsed="$(printf '%.2fs' "$elapsed")"
    else
      __cmd_elapsed=""
    fi
    __cmd_start=0
  else
    __cmd_elapsed=""
  fi

  set_title
  vcs_info
  build_prompt "$last_status"
}

add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd prompt_precmd

alias cls='clear'
alias c='clear'
alias q='exit'
alias reload!='source ~/.zshrc'
alias path='pathshow'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias mkdir='mkdir -p'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias psa='ps auxf'
alias ports='ss -tulpn'
alias ping='ping -c 5'
alias h='fc -l 1'
alias j='jobs -l'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias md='mkdir -p'
alias rd='rmdir'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias untar='tar -xvf'
alias svim='sudoedit'
alias svimdiff='sudo -e'

if command_exists eza; then
  alias ls='eza --group-directories-first --icons=never'
  alias ll='eza -lh --git --group-directories-first --icons=never'
  alias la='eza -la --group-directories-first --icons=never'
  alias l='eza -lah --git --group-directories-first --icons=never'
  alias lt='eza -lahT --git --group-directories-first --icons=never'
elif command_exists exa; then
  alias ls='exa --group-directories-first'
  alias ll='exa -lh --git --group-directories-first'
  alias la='exa -la --group-directories-first'
  alias l='exa -lah --git --group-directories-first'
  alias lt='exa -lahT --git --group-directories-first'
else
  alias ls='ls --color=auto -F'
  alias ll='ls --color=auto -lh'
  alias la='ls --color=auto -A'
  alias l='ls --color=auto -lah'
  alias lt='ls --color=auto -lahtr'
fi

if command_exists bat; then
  alias cat='bat --paging=never --style=plain'
elif command_exists batcat; then
  alias cat='batcat --paging=never --style=plain'
fi

alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gc='git commit'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gl='git log --oneline --decorate --graph --all'
alias glast='git log -1 HEAD --stat'
alias gpl='git pull --rebase --autostash'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gr='git restore'
alias ग्रs='git restore --staged'
alias ग्रh='git reset --hard'
alias gs='git status -sb'
alias gsh='git show --stat'
alias gst='git stash push'
alias gstp='git stash pop'
alias gsw='git switch'
alias gswc='git switch -c'
alias gtags='git tag'
alias gunstage='git restore --staged --worktree .'
alias gwip='git add -A && git commit -m "wip"'
alias groot='groot'

if command_exists ff; then
  alias f='ff'
  alias fhid='ff -H'
  alias ftext='ff --contains'
fi

if command_exists rg; then
  alias rg='rg --smart-case --hidden --glob "!.git"'
fi

if command_exists fastfetch; then
  alias sysinfo='fastfetch'
elif command_exists neofetch; then
  alias sysinfo='neofetch'
fi

if command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

if command_exists direnv; then
  eval "$(direnv hook zsh)"
fi

if command_exists lesspipe; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

for file in \
  /usr/share/fzf/key-bindings.zsh \
  /usr/local/share/fzf/key-bindings.zsh \
  "$HOME/.fzf/shell/key-bindings.zsh"
do
  [[ -r "$file" ]] && source "$file" && break
done

for file in \
  /usr/share/fzf/completion.zsh \
  /usr/local/share/fzf/completion.zsh \
  "$HOME/.fzf/shell/completion.zsh"
do
  [[ -r "$file" ]] && source "$file" && break
done

fastfetch
[[ -r "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -r "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"
[[ -r "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"
