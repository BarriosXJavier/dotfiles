# --- Core OMZ setup ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # Starship handles prompt
plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
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
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/go"

# --- PATH (safe) ---
# Always start with system defaults
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin"

# Add custom tool paths
export PATH="$PATH:/opt/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
export PATH="$PATH:$NVM_DIR/versions/node/v22.16.0/bin"
export PATH="$PATH:$HOME/.zvm/bin:$HOME/.zvm/self"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export PATH="$PATH:$HOME/.local/kitty.app/bin"
export PATH="$PATH:$HOME/.opencode/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

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
[[ -f "$HOME/.config/geminicli/secrets.env" ]] && source "$HOME/.config/geminicli/secrets.env"

# --- Atuin (better shell history) ---
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env" && eval "$(atuin init zsh)"

# --- Terminal Title ---
case "$TERM" in
  xterm*|rxvt*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
esac

# --- Custom Functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }

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

# Always use a steady block cursor
echo -ne "\e[1 q"

# --- SSH Agent ---
eval "$(ssh-agent -s)" > /dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null


# bun completions
[ -s "/home/maksim/.bun/_bun" ] && source "/home/maksim/.bun/_bun"
