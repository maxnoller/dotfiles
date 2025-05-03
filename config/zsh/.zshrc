# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

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
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load zsh-completions before Oh My Zsh
# Check if the completions plugin directory exists
ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
if [ -d "$ZSH_COMPLETIONS_DIR" ]; then
  fpath=("$ZSH_COMPLETIONS_DIR/src" $fpath)
  # Initialize completion system if not already done
  # Check if compinit is already loaded to avoid double loading
  if ! command -v compinit >/dev/null 2>&1 || ! declare -f compinit > /dev/null; then
    autoload -U compinit && compinit
  fi
fi

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
# Add ~/.local/bin to PATH if it exists and is not already included
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
# export PATH=$HOME/.local/bin:$PATH # Old line commented out/removed

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# UV run autocomplete while issues not fixed
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# Aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

alias python="python3"
alias pip="pip3"

alias :q="exit"

# BEGIN ANSIBLE MANAGED BLOCK NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# END ANSIBLE MANAGED BLOCK NVM
#
# act setup
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
