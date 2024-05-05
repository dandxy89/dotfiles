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

# Alias to spawn a new tmux session with 2 windows
tmx () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s RustDev
    tmux new-window -n terminal
    # -d to prevent current window from changing
    tmux new-window -d -n nvim
    tmux new-window -d -n lazygit
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
alias weatherDubai="curl -4 https://wttr.in/Dubai"

alias reloadshell="source $HOME/.zshrc"
alias ll='ls -all'

alias ..='cd ..'
alias ls='ls --color=auto'
alias e='exit'

alias top="htop"
alias rg='rg -uuu'

alias du='du -csh'
alias df='df -h'
alias grep='grep --color=auto'
alias diff="colordiff -ru"

# Default options for fd, a faster find.
alias fd='fd --one-file-system --hidden'

# Replace netstat command on macOS to find ports used by apps
alias netstat="sudo lsof -i -P"

alias ez='v ~/.zshrc'
alias eb='v ~/.bashrc'
alias alconfig="nvim ~/.config/alacritty/alacritty.yml"

export SCRIPTS="$DOTFILES/scripts"
alias nanos2dt="sh $SCRIPTS/nanos_to_dt"
alias urlEncode="sh $SCRIPTS/urlencode"

# fzf aliases
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'" # use fp to do a fzf search and preview the files
alias vf='v $(fp)' # search for a file with fzf and open it in vim

# Changing "ls" to "eza"
alias ls='eza -al --color=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format
alias lt='eza -aT --color=always --group-directories-first' # tree listing

### ARCHIVE EXTRACTION
# usage: ex <file>
function ex {
     if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
     else
        for n in "$@"
        do
          if [ -f "$n" ] ; then
              case "${n%,}" in
                *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                             tar xvf "$n"       ;;
                *.lzma)      unlzma ./"$n"      ;;
                *.bz2)       bunzip2 ./"$n"     ;;
                *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                *.gz)        gunzip ./"$n"      ;;
                *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                *.z)         uncompress ./"$n"  ;;
                *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                             7z x ./"$n"        ;;
                *.xz)        unxz ./"$n"        ;;
                *.exe)       cabextract ./"$n"  ;;
                *.cpio)      cpio -id < ./"$n"  ;;
                *.cba|*.ace)      unace x ./"$n"      ;;
                *)
                             echo "ex: '$n' - unknown archive method"
                             return 1
                             ;;
              esac
          else
              echo "'$n' - file does not exist"
              return 1
          fi
        done
    fi
}

# history search using fzf
h(){
    $(cat ~/.zsh_history | awk -F ';' '{ $1="" ; print }' | fzf --tac )
}

# ~~~~~~~~~~~~~~~ Neofetch ~~~~~~~~~~~~~~~~~~~~~~~~~
# brew install neofetch

# ~~~~~~~~~~~~~~~ Rust ~~~~~~~~~~~~~~~~~~~~~~~~~
# export CARGO_INCREMENTAL=1
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

# brew install gawk
alias update_pip_friends="pip3 list --outdated | gawk -F ' ' 'NR>2{print$1}' | xargs pip3 install --upgrade"

# ~~~~~~~~~~~~~~~ alacritty ~~~~~~~~~~~~~~~~
# brew install --cask alacritty

# ~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~
# https://github.com/atuinsh/atuin
eval "$(atuin init zsh)"

# Init pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ~~~~~~~~~~~~~~~ starship ~~~~~~~~~~~~~~~~
eval "$(starship init zsh)"
