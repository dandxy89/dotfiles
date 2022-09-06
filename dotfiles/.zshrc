if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"
alias dd="source .venv/bin/activate; nvim ."

# Path Extenstions
export PATH="/usr/local/bin/chromedriver:$PATH"
export PATH="$PATH:/Users/dixeda/.local/bin"
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"

# PIPENV Variables
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PIPENV_IGNORE_VIRTUALENVS=1
export PIPENV_VENV_IN_PROJECT=1
# eval "$(pipenv --completion)"  # Shell Completion

# PyENV
export PATH="/usr/local/opt/swig@3/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=true
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Rust
alias cb="cargo build --release"
alias ct="cargo test"
alias cc="cargo check"
alias clippy="cargo clippy --all-targets --all-features -- -D warnings"
export RUST_LOG=info

# Gurobi
export GRB_LICENSE_FILE="/Library/gurobi952/macos_universal2/gurobi.lic"
export GUROBI_HOME="/Library/gurobi952/macos_universal2"

# Connecting to the AWS
alias s2a='function(){eval $($(command -v saml2aws) script --shell=bash -a "$@");}'
alias loginAWS='saml2aws login -a woodmac-nonprod'

# Disable AWS TELEMETRY
export SAM_CLI_TELEMETRY=0

# Rust stuff
if [ ! -f "$HOME/.config/rustlang/autocomplete/rustup" ]; then
    mkdir -p ~/.config/rustlang/autocomplete
    rustup completions bash rustup >> ~/.config/rustlang/autocomplete/rustup
fi

export PATH="/Users/i98012/Rust/rust-analyzer/crates/rust-analyzer:$PATH"
export CARGO_INCREMENTAL=1
export RUSTFLAGS="-C target-cpu=native"
export RUST_BACKTRACE=1
#export RUST_BACKTRACE=full
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"

# Poetry
export PATH="$HOME/.poetry/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# To Pqrquet
alias toParquet='python3 /Users/i98012/.config/nvim/to_csv.py'

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd:dd: -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
