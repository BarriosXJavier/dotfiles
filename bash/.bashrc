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
export GIT_EDITOR=nvim
export MANPAGER="nvim +Man!"

export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/go"

# --- PATH 
# Start with system directories first
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin"

# Add custom tools
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

# --- Node / NVM ---
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- Starship prompt ---
eval "$(starship init bash)"

# --- Rust environment ---
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --- Lua via luaver ---
[ -s "$HOME/.luaver/luaver" ] && . "$HOME/.luaver/luaver"
[ -s "$HOME/.luaver/completions/luaver.bash" ] && . "$HOME/.luaver/completions/luaver.bash"

# --- ble.sh (enhanced readline) ---
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"

# --- Atuin shell history ---
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
eval "$(atuin init bash)"

# --- Bash preexec (optional) ---
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# --- SSH Agent ---
eval "$(ssh-agent -s)" > /dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null

# --- Secrets / project envs ---
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
[[ -f "$HOME/.config/geminicli/secrets.env" ]] && source "$HOME/.config/geminicli/secrets.env"

. "/home/maksim/.deno/env"
