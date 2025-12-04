# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Gitstatus/p10k performance: disable expensive untracked scanning in large repos.
# Must be set BEFORE oh-my-zsh loads the theme (and thus p10k/gitstatus).
export GITSTATUS_ENABLE_UNTRACKED=0

# Optimized plugins - removed redundant ones and reordered for better loading
plugins=(
    git                     # Core git functionality
    docker                  # Docker completion
    python                  # Python utilities
    pip                     # pip completion
    tmux                    # tmux integration
    ubuntu                  # Ubuntu-specific commands
    uv                      # uv package manager
    gitignore               # gitignore templates
    zsh-autosuggestions     # Must be before syntax-highlighting
    zsh-syntax-highlighting # Must be last
)

# Optimize completion system - single initialization
# Load zsh-completions before Oh My Zsh
ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
if [[ -d "$ZSH_COMPLETIONS_DIR" ]]; then
  fpath=("$ZSH_COMPLETIONS_DIR/src" $fpath)
fi

# Performance optimization: skip some expensive git operations
DISABLE_UNTRACKED_FILES_DIRTY="true"
DISABLE_AUTO_UPDATE="true"  # Disable automatic updates for faster startup

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# PATH and Environment Setup
# ============================================================================

# Consolidate PATH modifications
typeset -U path  # Remove duplicates automatically
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    $path
)

# ============================================================================
# Completions and Functions
# ============================================================================

# Initialize completion system once
autoload -Uz compinit
# Performance optimization: only rebuild cache if it's older than 24 hours
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
    compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# zstyle optimizations
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive completion

# UV completion fix - only if uv is available
if command -v uv &> /dev/null; then
    _uv_run_mod() {
        if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
            _arguments '*:filename:_files'
        else
            _uv "$@"
        fi
    }
    compdef _uv_run_mod uv
fi

# ============================================================================
# Aliases
# ============================================================================

# Editor aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Python aliases
alias python="python3"
alias pip="pip3"

# Convenience aliases
alias :q="exit"
alias ll="ls -la"
alias la="ls -la"
alias l="ls -l"

# ============================================================================
# Final Setup
# ============================================================================

# Load p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load any custom completions
if [[ -d ~/.zfunc ]]; then
    fpath=(~/.zfunc $fpath)
fi
fpath=(~/.zsh/completions $fpath)


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Moon task runner - Added by Claude Code
export PATH="$HOME/.moon/bin:$PATH"

# Moon shell completions
if command -v moon &> /dev/null; then
  eval "$(moon completions --shell zsh)"
fi

# proto
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";