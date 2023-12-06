
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# # Use Sublime from ZSH (# sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl)

# # Make zsh default shell
# # sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

plugins=(
    git
    colored-man-pages
    colorize
    pip
    python
    brew
)

# # UserConfig
alias myip="curl http://ipecho.net/plain; echo"
alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"
alias vim="nvim -n"
alias weather="curl -4 https://wttr.in/durham"
alias reloadshell="source $HOME/.zshrc"
alias ll='ls -all'

# # General
export EDITOR="nvim"
export VISUAL="nvim"

export LANG=en_GB.UTF-8
export EDITOR="nvim"
export GIT_EDITOR=$EDITOR
export UPDATE_ZSH_DAYS=3
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd:dd: -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# Rust
export CARGO_INCREMENTAL=1
export RUST_LOG=info
# export RUST_BACKTRACE=1
alias rust_analyzer_update="cd ~/Dan/rust-analyzer && git pull && cargo xtask install" # Update rust-analyzer && rebuild the LSP
alias clippy="cargo clippy --all-targets --all-features -- -D warnings"
alias ct="cargo nextest run" # alias ct="cargo test"
alias cr="cargo build --release --all-features"
alias cc="cargo check --all-features"
alias cf="cargo +nightly fmt"

# Disable AWS TELEMETRY
export SAM_CLI_TELEMETRY=0

# Other
alias f1n="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Sport/F1"
alias htn="/Applications/Firefox.app/Contents/MacOS/firefox --new-tab https://www.newsnow.co.uk/h/Hot+Topics"

# Custom
alias ..='cd ..'

## Nvim
## brew nvim: `cd /Users/sigma-dan/Library/Caches/Homebrew/neovim--git`
alias brew_nvim="brew install --HEAD neovim"
alias dd="source .venv/bin/activate; nvim -n"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Brew installed sources
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    autoload -Uz compinit
    compinit
  fi
