#Exports
export TERM='alacritty'
export TERMINAL='alacritty'
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# jispwoso ; kafeitu ; juanghurtado
ZSH_THEME="juanghurtado"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

# Sources
source $ZSH/oh-my-zsh.sh
source <(ng completion script)
