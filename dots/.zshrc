# =====================================================
# Oh My Zsh Configuration
# =====================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Enhanced plugin list with useful additions
plugins=(
    git
    docker
    rust
    fzf
    brew
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =====================================================
# Environment Variables
# =====================================================
export LANG=en_GB.UTF-8
export UPDATE_ZSH_DAYS=1

# Editor configuration
export EDITOR="$HOME/Projects/nvim-macos-arm64/bin/nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

# Package configuration
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"

# =====================================================
# PATH Configuration
# =====================================================
# Add custom nvim to PATH
export PATH="$HOME/Projects/nvim-macos-arm64/bin:$PATH"

# Add local bin directories
export PATH="$PATH:$HOME/.local/bin"

# Add PostgreSQL to PATH
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# =====================================================
# External Tool Initialization
# =====================================================
# Atuin shell history
if [[ -f "$HOME/.atuin/bin/env" ]]; then
    . "$HOME/.atuin/bin/env"
    eval "$(atuin init zsh)"
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Docker completions
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

# =====================================================
# Aliases - Editor & Navigation
# =====================================================
# Editor aliases with virtual environment activation
alias vim='[[ -d .venv ]] && source .venv/bin/activate; nvim -n'
alias nvim='[[ -d .venv ]] && source .venv/bin/activate; nvim -n'

# Configuration editing
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -alh'
alias la='ls -la'
alias ls='ls --color=auto'

# Quick actions
alias e='exit'
alias reloadshell='source $HOME/.zshrc'

# =====================================================
# Aliases - System & Utilities
# =====================================================
# System monitoring
alias top='htop'
alias netstat='sudo lsof -i -P'

# File operations
alias du='du -csh'
alias df='df -h'
alias grep='grep --color=auto'
alias diff='colordiff -ru'  # brew install colordiff
alias fd='fd --one-file-system --hidden'
alias rg='rg -uuu'

# Network & Info
alias myip='curl -s http://ipecho.net/plain; echo'
alias weather='curl -4 https://wttr.in/durham'
alias weatherDubai='curl -4 https://wttr.in/Dubai'

# =====================================================
# Aliases - FZF Integration
# =====================================================
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias vf='nvim $(fp)'

# =====================================================
# Aliases - Applications
# =====================================================
alias f1n='/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Sport/F1'
alias htn='/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Hot+Topics'

# =====================================================
# Rust Development Configuration
# =====================================================
export CARGO_REGISTRY_TOKEN=TODO

# Rust aliases for development workflow
alias clippy='cargo clippy --all-targets --all-features -- -D warnings'
alias ct='cargo nextest run --all-features --no-fail-fast'
alias cr='cargo build --release --all-features'
alias cc='cargo check --all-features'
alias cf='cargo +nightly fmt'
alias sweep_target='cargo sweep --recursive --time 0 ~/Work'  # cargo install cargo-sweep

# =====================================================
# Functions
# =====================================================
# Tmux session management
tmx() {
    local session_name="RustDev"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -d -s "$session_name"
        tmux new-window -n terminal
        tmux new-window -d -n nvim
        tmux new-window -d -n lazygit
        tmux attach-session -d -t "$session_name"
    fi
}
