# ~~~~~~~~~~~~~~~ ZSH Setup ~~~~~~~~~~~~~~~~~~~~~~~
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# Use Sublime from ZSH (# sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl)

# Make zsh default shell
# sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~~~~~~~~~~~~~~~ Tmux ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Alias to spawn a new tmux session with 3 windows
tmx () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s RustDev
    tmux new-window -n Win1
    # -d to prevent current window from changing
    tmux new-window -d -n Win2
    tmux new-window -d -n Win3
    # -d to detach any other client (which there shouldn't be, since you just created the session).
    tmux attach-session -d -t RustDev
}

# ~~~~~~~~~~~~~~~ ZSH Plugins ~~~~~~~~~~~~~~~~~~~~
plugins=(
    git
    colored-man-pages
    colorize
    pip
    python
    brew
    rust
    poetry
)

# ~~~~~~~~~~~~~~~ General ~~~~~~~~~~~~~~~~~~~~~~~~
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"

export REPOS="$HOME/Sigma"
alias sigma='cd $REPOS'

export DOTFILES="$HOME/Dan/dotfiles"
alias dot='cd $DOTFILES'

export SCRIPTS="$DOTFILES/scripts"

export LANG=en_GB.UTF-8
export EDITOR="nvim"
export GIT_EDITOR=$EDITOR
export UPDATE_ZSH_DAYS=3

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd:dd: -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# ~~~~~~~~~~~~~~~ User Config ~~~~~~~~~~~~~~~~~~~
alias myip="curl http://ipecho.net/plain; echo"
alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"

alias weather="curl -4 https://wttr.in/durham"
alias reloadshell="source $HOME/.zshrc"
alias ll='ls -all'

alias ..='cd ..'
alias ls='ls --color=auto'
alias e='exit'

alias ez='v ~/.zshrc'
alias eb='v ~/.bashrc'
alias alconfig="nvim ~/.config/alacritty/alacritty.yml"

export SCRIPTS="$DOTFILES/scripts"
alias nanos2dt="sh $SCRIPTS/nanos_to_dt"
alias urlEncode="sh $SCRIPTS/urlencode"

# fzf aliases
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'" # use fp to do a fzf search and preview the files
alias vf='v $(fp)' # search for a file with fzf and open it in vim

# ~~~~~~~~~~~~~~~ Neofetch ~~~~~~~~~~~~~~~~~~~~~~~~~
# brew install neofetch

# ~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~
# export CARGO_INCREMENTAL=1
export CARGO_REGISTRY_TOKEN=""
export RUST_LOG=info
alias rust_analyzer_update="cd ~/Dan/rust-analyzer && git pull && cargo xtask install" # Update rust-analyzer && rebuild the LSP

# https://corrode.dev/blog/tips-for-faster-rust-compile-times/
# alias cargo="RUSTFLAGS='-Z threads=8' cargo +nightly"

# https://rust.code-maven.com/extreme-clippy
# [lints.clippy]
# cargo        = { priority = -1, level = "deny" }
# complexity   = { priority = -1, level = "deny" }
# correctness  = { priority = -1, level = "deny" }
# nursery      = { priority = -1, level = "deny" }
# pedantic     = { priority = -1, level = "deny" }
# perf         = { priority = -1, level = "deny" }
# restriction  = { priority = -1, level = "deny" }
# style        = { priority = -1, level = "deny" }
# suspicious   = { priority = -1, level = "deny" }

# cargo_common_metadata = "allow"
# missing_docs_in_private_items = "allow"
# blanket_clippy_restriction_lints = "allow" # I like Extreme clippy
# implicit_return = "allow" # This is the more common way in rust
# dbg_macro = "allow"

alias clippy="cargo clippy --all-targets --all-features -- -D warnings"
alias ct="cargo nextest run --all-features --no-fail-fast" # alias ct="cargo test"
alias cr="cargo build --release --all-features"
alias cc="cargo check --all-features"
alias cf="cargo +nightly fmt"
alias sweep_target="cargo sweep --recursive --time 0 ~/Sigma" # cargo install cargo-sweep

# ~~~~~~~~~~~~~~~ AWS ~~~~~~~~~~~~~~~~~~~~~~~~ OMIT ME

# ~~~~~~~~~~~~~~~ NewsNow ~~~~~~~~~~~~~~~~~~~
alias f1n="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Sport/F1"
alias htn="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Hot+Topics"

# ~~~~~~~~~~~~~~~ Neovim ~~~~~~~~~~~~~~~~~~~
## brew nvim: `cd /Users/sigma-dan/Library/Caches/Homebrew/neovim--git`
alias brew_nvim="brew install --HEAD neovim"
alias v="source .venv/bin/activate; nvim -n"
alias vim="source .venv/bin/activate; nvim -n"
alias dd="source .venv/bin/activate; nvim -n"

# ~~~~~~~~~~~~~~~ Datadog ~~~~~~~~~~~~~~~~~~~ OMIT ME

# ~~~~~~~~~~~~~~~ Telegram F1 Bot ~~~~~~~~~~~ OMIT ME

# ~~~~~~~~~~~~~~~ Python ~~~~~~~~~~~~~~~~~~~
export POETRY_VIRTUALENVS_IN_PROJECT=true

# ~~~~~~~~~~~~~~~ Brew Stuff ~~~~~~~~~~~~~~~~
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    autoload -Uz compinit
    compinit
  fi

# brew install gawk
alias update_pip_friends="pip3 list --outdated | gawk -F ' ' 'NR>2{print$1}' | xargs pip3 install --upgrade"

# ~~~~~~~~~~~~~~~ alacritty ~~~~~~~~~~~~~~~~
# brew install --cask alacritty

# ~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~
eval "$(atuin init zsh)"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/sigma-dan/.bun/_bun" ] && source "/Users/sigma-dan/.bun/_bun"

# Init pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ~~~~~~~~~~~~~~~ starship ~~~~~~~~~~~~~~~~
eval "$(starship init zsh)"
