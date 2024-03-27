##
# Import configs externals
##
export ZSH="$HOME/.config/zsh/.oh-my-zsh"

##
# Themes config with Oh My ZSH
##
ZSH_THEME="jispwoso"
# For use = jispwoso ; kafeitu ; juanghurtado ; spaceship

##
# Config Spaceship Theme
##
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  python        # Python section
  node          # Node section
  venv           # virtualenv section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

##
# Plugins to Oh My ZSH
##
plugins=(
    git
    github
    python
    pip
    poetry
    node
    npm
    yarn
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    zsh-navigation-tools
)

##
# Sourcers
##
source $ZSH/oh-my-zsh.sh
