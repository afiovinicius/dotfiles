##
# Exports
##
export ZSH="$HOME/.config/zsh"
export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

##
# History
##
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt inc_append_history

##
# Completion
##
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

##
# BindKeys
##
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

##
# Alias
##
alias ls='eza -lbF --icons'
alias la='eza -lbhHigUmuSa --time-style=long-iso --icons'
alias cat='bat'

##
# Plugins
##
fpath+=($ZSH/plugins/zsh-completions/src)
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source $ZSH/plugins/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##
# Evals
##
eval "$(starship init zsh)"
eval "$(uv generate-shell-completion zsh)"

##
# Loadrs
##
lazy_load_nvm() {
  unset -f node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

node() { lazy_load_nvm; node "$@"; }
npm()  { lazy_load_nvm; npm "$@"; }
npx()  { lazy_load_nvm; npx "$@"; }

lazy_load_ng() {
  unset -f ng
  command -v ng &>/dev/null && source <(ng completion script)
}

ng() {
  lazy_load_ng
  command ng "$@"
}
