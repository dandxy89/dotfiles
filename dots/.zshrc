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
alias vim="nvim -n"
alias weather="curl -4 https://wttr.in/durham"
alias reloadshell="source $HOME/.zshrc"
alias ll='ls -all'
alias alconfig="nvim ~/.config/alacritty/alacritty.yml"
alias ..='cd ..'
alias ls='ls --color=auto'
alias e='exit'
alias ez='v ~/.zshrc'
alias eb='v ~/.bashrc'

# fzf aliases
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'" # use fp to do a fzf search and preview the files
alias vf='v $(fp)' # search for a file with fzf and open it in vim

# ~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~
export CARGO_INCREMENTAL=1
export RUST_LOG=info
alias rust_analyzer_update="cd ~/Dan/rust-analyzer && git pull && cargo xtask install" # Update rust-analyzer && rebuild the LSP
alias clippy="cargo clippy --all-targets --all-features -- -D warnings"
alias ct="cargo nextest run --all-features" # alias ct="cargo test"
alias cr="cargo build --release --all-features"
alias cc="cargo check --all-features"
alias cf="cargo +nightly fmt"
alias sweep_target="cargo sweep --recursive --time 0 ~/Sigma" # cargo install cargo-sweep

# ~~~~~~~~~~~~~~~ AWS ~~~~~~~~~~~~~~~~~~~~~~~~ OMIT ME
export SAM_CLI_TELEMETRY=0

# ~~~~~~~~~~~~~~~ NewsNow ~~~~~~~~~~~~~~~~~~~
alias f1n="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Sport/F1"
alias htn="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Hot+Topics"

# ~~~~~~~~~~~~~~~ Neovim ~~~~~~~~~~~~~~~~~~~
## brew nvim: `cd /Users/sigma-dan/Library/Caches/Homebrew/neovim--git`
alias brew_nvim="brew install --HEAD neovim"
alias v="source .venv/bin/activate; nvim -n"

# ~~~~~~~~~~~~~~~ Datadog ~~~~~~~~~~~~~~~~~~~ OMIT ME

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# ~~~~~~~~~~~~~~~ alacritty ~~~~~~~~~~~~~~~~
# brew install --cask alacritty

# ~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~
# [[ ! -r /Users/sigma-dan/.opam/opam-init/init.zsh ]] || source /Users/sigma-dan/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
# export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
