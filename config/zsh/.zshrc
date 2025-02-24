# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    npm 
    node
    python
    pip
    tmux
    nvm
    ubuntu
    uv
    gitignore
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/.local/bin:$PATH

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

alias python="python3"
alias pip="pip3"

alias :q="exit"