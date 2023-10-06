# _____ _                                 _____           _
#|_   _| |                               |_   _|         | |
#  | | | |__   ___  _ __ ___   __ _ ___    | |_   _ _   _| |
#  | | | '_ \ / _ \| '_ ` _ \ / _` / __|   | | | | | | | | |
#  | | | | | | (_) | | | | | | (_| \__ \   | | |_| | |_| | |
#  \_/ |_| |_|\___/|_| |_| |_|\__,_|___/   \_/\__,_|\__,_|_|
#
# My bash config. Not much to see here.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:erasedups        # no duplicate entries

### SHOPT
shopt -s histappend     # do not overwrite history
shopt -s checkwinsize   # checks term size when bash regains control
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s cdspell        # autocorrects cd misspellings

set -o vi               # use vi keybindings instead of emacs keybindings (readline)

bind "set colored-completion-prefix on"
bind "set colored-stats on"
bind "set completion-ignore-case on" # enable case-insensitive tab completion

# ctrl-l has been missed since vi instead emacs keybindings are used
bind -m vi-insert "\C-l":clear-screen

# enabling search forward (ctrl-s)
stty -ixon

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

export HISTTIMEFORMAT="%H:%M:%S "
export HISTIGNORE="ls:history"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}[\[\033[1;34m\]\u\[\033[0m\]@\h \W]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# https://wiki.ubuntuusers.de/Paketverwaltung/Tipps/
function apt-history(){
      case "$1" in
        install)
              cat /var/log/{dpkg.log,dpkg.log.1} | grep 'install '
              ;;
        upgrade|remove)
              cat /var/log/{dpkg.log,dpkg.log.1} | grep $1
              ;;
        rollback)
              cat /var/log/{dpkg.log,dpkg.log.1} | grep upgrade | \
                  grep "$2" -A10000000 | \
                  grep "$3" -B10000000 | \
                  awk '{print $4"="$5}'
              ;;
        *)
              cat /var/log/{dpkg.log,dpkg.log.1}
              ;;
      esac
}

# https://linux-club.de/wiki/opensuse/Farbe_in_der_Konsole
# Farbiger Errorlevel im Prompt
PROMPT_COMMAND='LASTERROR="[$?]" ; test "$LASTERROR" = "[0]" || echo -ne "\033[93;41m${LASTERROR}\033[0m"'
export PROMPT_COMMAND

### PATH
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

### SETTING THE STARSHIP PROMPT ###

if command -v starship &> /dev/null
then
    #if [ "$TERM" != "linux" ]; then
        eval "$(starship init bash)"
    #fi
fi


# Added neofetch when opening a terminal
#if command -v neofetch &> /dev/null
#then
#    neofetch
#fi


export EDITOR="/usr/bin/vim"
export TERMINAL="/usr/bin/alacritty"
export BROWSER="/usr/bin/brave-browser"
export READER="/usr/bin/zathura"
export OPENER="xdg-open" # needed by lf

# https://wiki.archlinux.org/title/HiDPI
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
#export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.

### "bat" as manpager
#export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
### "vim" as manpager
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
    bind '"\C-o":"lfcd\C-m"'
    alias lf="lfcd"
fi

eval "$(fasd --init auto)"

if [ -f "$HOME/.fzf-tab-completion/bash/fzf-bash-completion.sh" ]; then
    source $HOME/.fzf-tab-completion/bash/fzf-bash-completion.sh
    bind -x '"\t": fzf_bash_completion'
fi

if [ -f "$HOME/.config/broot/launcher/bash/br" ]; then
    source $HOME/.config/broot/launcher/bash/br
    bind -x '"\C-b": br'
fi
