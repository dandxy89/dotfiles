# =====================================================
# Oh My Zsh Configuration
# =====================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    git
    docker
    rust
    fzf
    brew
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# =====================================================
# Shell Options
# =====================================================
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
HISTSIZE=50000
SAVEHIST=50000

# =====================================================
# Environment Variables
# =====================================================
export LANG=en_GB.UTF-8
export UPDATE_ZSH_DAYS=1

export XDG_DATA_HOME="$HOME/Library/Application Support"

export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export GPG_TTY=$(tty)

# Homebrew prefix (Apple Silicon vs Intel vs Linux)
if [[ -d /opt/homebrew ]]; then
    BREW_PREFIX=/opt/homebrew
elif command -v brew >/dev/null 2>&1; then
    BREW_PREFIX=$(brew --prefix)
fi

if [[ -n "$BREW_PREFIX" ]]; then
    export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

# =====================================================
# PATH Configuration (dedup-safe)
# =====================================================
path_prepend() {
    [[ -d "$1" ]] || return
    [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}
path_append() {
    [[ -d "$1" ]] || return
    [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"
}

path_prepend "$HOME/Projects/nvim-macos-arm64/bin"
path_append "$HOME/.local/bin"
[[ -n "$BREW_PREFIX" ]] && path_prepend "$BREW_PREFIX/opt/postgresql@15/bin"
command -v go >/dev/null 2>&1 && path_append "$(go env GOPATH)/bin"
export PATH

# =====================================================
# Completion
# =====================================================
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
# Cache compinit: full rebuild at most once every 24h
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
autoload -U +X bashcompinit && bashcompinit
[[ -n "$BREW_PREFIX" && -x "$BREW_PREFIX/bin/terraform" ]] && \
    complete -o nospace -C "$BREW_PREFIX/bin/terraform" terraform

# =====================================================
# External Tool Initialization
# =====================================================
if [[ -f "$HOME/.atuin/bin/env" ]]; then
    . "$HOME/.atuin/bin/env"
    eval "$(atuin init zsh)"
fi

if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# =====================================================
# Aliases - Editor & Navigation
# =====================================================
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -alh'
alias la='ls -la'

# Colour-aware ls: GNU takes --color, BSD (macOS) takes -G
if ls --color=auto / >/dev/null 2>&1; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

alias e='exit'
alias reloadshell='source $HOME/.zshrc'

# =====================================================
# Aliases - System & Utilities
# =====================================================
command -v htop >/dev/null 2>&1 && alias top='htop'
alias netstat='sudo lsof -i -P'

alias du='du -csh'
alias df='df -h'
alias grep='grep --color=auto'
command -v colordiff >/dev/null 2>&1 && alias diff='colordiff -ru'
alias fd='fd --one-file-system --hidden'
alias rg='rg -uuu'

alias myip='curl -s http://ipecho.net/plain; echo'
alias weather='curl -4 https://wttr.in/durham'
alias weatherDubai='curl -4 https://wttr.in/Dubai'

# =====================================================
# FZF Integration
# =====================================================
# NOTE: FZF_*_COMMAND runs in a subshell; zsh aliases don't apply there,
# so flags must be specified inline below.
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Shared fd flags — relies on ~/.config/fd/ignore for excludes
# (symlinked from configs/fd/ignore in this repo).
_FD_FLAGS='--hidden --follow --strip-cwd-prefix --no-ignore-vcs'
export FZF_DEFAULT_COMMAND="fd --type f ${_FD_FLAGS}"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d ${_FD_FLAGS}"
export FZF_DEFAULT_OPTS='--cycle --tiebreak=end --history-size=10000 --border --height=80% --layout=reverse --bind=ctrl-/:toggle-preview,ctrl-_:toggle-preview,ctrl-u:preview-page-up,ctrl-d:preview-page-down'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} 2>/dev/null | head -100'"
export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window=down:3:wrap'

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
alias clippy='cargo clippy --all-targets --all-features -- -D warnings'
alias ct='cargo nextest run --all-features --no-fail-fast'
alias cr='cargo build --release --all-features'
alias cc='cargo check --all-features'
alias cf='cargo +nightly fmt'
alias sweep_target='cargo sweep --recursive --time 0 ~/Work'

# =====================================================
# Functions
# =====================================================
# Tmux session: tmx [name] (defaults to RustDev)
tmx() {
    local session_name="${1:-RustDev}"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -d -s "$session_name"
        tmux new-window -n terminal
        tmux new-window -d -n nvim
        tmux attach-session -d -t "$session_name"
    fi
}

# =====================================================
# Local overrides & secrets (not committed)
# =====================================================
# Put machine-specific vars (e.g. CARGO_REGISTRY_TOKEN) in ~/.secrets
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
