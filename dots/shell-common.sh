# shell-common.sh — portable shell config (zsh + bash)
# Sourced from ~/.zshrc / ~/.bashrc by the dotfiles bootstrap.
# Keep this free of oh-my-zsh / brew / macOS-only assumptions.

# =====================================================
# Editor
# =====================================================
export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

# =====================================================
# Aliases - Navigation
# =====================================================
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
# NOTE: FZF_*_COMMAND runs in a subshell; shell aliases don't apply there,
# so flags must be specified inline below.
if command -v fzf >/dev/null 2>&1; then
    if [ -n "${ZSH_VERSION:-}" ]; then
        source <(fzf --zsh)
    elif [ -n "${BASH_VERSION:-}" ]; then
        eval "$(fzf --bash)"
    fi
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
