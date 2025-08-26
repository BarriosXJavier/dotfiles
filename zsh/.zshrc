# --- Core OMZ setup ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # Starship handles prompt
plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting  # Faster than zsh-syntax-highlighting
  zsh-vi-mode
)
source $ZSH/oh-my-zsh.sh

# --- Editors & Pager ---
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=nvim
export MANPAGER="nvim +Man!"

# --- Environment Variables ---
export NVM_DIR="$HOME/.nvm"

# --- PATH ---
export PATH="/opt/bin:/opt/nvim-linux-x86_64/bin:$HOME/.bun/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.nvm/versions/node/v22.16.0/bin:$HOME/.zvm/bin:$HOME/.zvm/self:$HOME/bin:/usr/local/bin:/usr/sbin:/sbin:$PATH"

# --- Prompt ---
eval "$(starship init zsh)"

# --- History Configuration ---
HISTSIZE=2000  
SAVEHIST=2000  
HISTFILE=~/.zsh_history
setopt append_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# --- Completion Configuration ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# --- Aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias p='pwd ; ls -CF'
alias cl='clear'
alias cc="clang -Wall -Wextra"
alias ncal="ncal -b"
alias reload="source ~/.zshrc"

# --- Conditional Environment Sources ---
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -s ~/.luaver/luaver ]] && source ~/.luaver/luaver
[[ -s ~/.luaver/completions/luaver.bash ]] && source ~/.luaver/completions/luaver.bash

if [[ -f "$HOME/.config/geminicli/secrets.env" ]]; then
  source "$HOME/.config/geminicli/secrets.env"
fi


# --- Atuin (better shell history) ---
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh)"
fi

# --- Bun ---
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# --- Terminal Title ---
case "$TERM" in
  xterm*|rxvt*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
esac

# --- Custom Functions ---
mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# --- Key Bindings ---
zvm_after_init_commands+=('bindkey "^R" history-incremental-search-backward')
