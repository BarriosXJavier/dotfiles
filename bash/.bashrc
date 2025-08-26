# ~/.bashrc: executed by bash(1) for non-login shells.

# --- Early exit for non-interactive shells ---
case $- in
*i*) ;;
*) return ;;
esac

set -o vi
# --- History configuration ---
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=1000

# --- Terminal behavior ---
shopt -s checkwinsize # Auto-update terminal size

# --- lesspipe for better less ---
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# --- Detect chroot environment ---
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# --- Prompt and terminal title ---
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
esac

# --- Enable color support for common commands ---
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# --- Handy aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias cc="clang -Wall -Wextra"
alias ncal='ncal -C'
alias cal='ncal -y'
alias p='pwd ; ls -CF'

# --- Load additional aliases ---
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# --- Bash completion ---
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Environment variables ---
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=vim

export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/go"

export PATH="/opt/nvim-linux-x86_64/bin:$BUN_INSTALL/bin:/usr/local/go/bin:$GOPATH/bin:$PATH"
export PATH="/opt/bin:$PATH"

export MANPAGER="nvim +Man!"

# --- NVM ---
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- Starship prompt ---
eval "$(starship init bash)"

# --- Rust environment ---
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --- Lua via luaver ---
[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver
[ -s ~/.luaver/completions/luaver.bash ] && . ~/.luaver/completions/luaver.bash

# --- ble.sh (enhanced readline) ---
[ -f ~/.local/share/blesh/ble.sh ] && source ~/.local/share/blesh/ble.sh

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"
PATH=/opt/bin:/opt/nvim-linux-x86_64/bin:/home/maksim/.bun/bin:/usr/local/go/bin:/home/maksim/go/bin:/home/maksim/.local/bin:/home/maksim/.cargo/bin:/home/maksim/.nvm/versions/node/v22.16.0/bin:/opt/bin:/opt/nvim-linux-x86_64/bin:/home/maksim/.bun/bin:/usr/local/go/bin:/home/maksim/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin:/home/maksim/.zvm/bin:/home/maksim/.zvm/self/:/home/maksim/.zvm/bin:/home/maksim/.zvm/self/:~/.config/rofi/scripts

[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

if [[ -f "$HOME/.config/geminicli/secrets.env" ]]; then
  source "$HOME/.config/geminicli/secrets.env"
fi

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
