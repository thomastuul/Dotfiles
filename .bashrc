#
#   ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#   ██████╔╝███████║███████╗███████║██████╔╝██║
#   ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
#██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# remove duplicate entries, ignore lines beginning with a space
HISTCONTROL=erasedups:ignorespace

### SHOPT
shopt -s histappend   # do not overwrite history
shopt -s checkwinsize # checks term size when bash regains control
shopt -s cmdhist      # save multi-line commands in history as single line
shopt -s cdspell      # autocorrects cd misspellings

set -o vi # use vi keybindings instead of emacs keybindings (readline)

bind "set colored-completion-prefix on"
bind "set colored-stats on"
bind "set completion-ignore-case on" # enable case-insensitive tab completion

# ctrl-l has been missed since vi instead emacs keybindings are used
bind -m vi-insert "\C-l":clear-screen

# enabling search forward (ctrl-s) when stdin is a terminal
[[ -t 0 ]] && stty -ixon

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

export HISTTIMEFORMAT="%H:%M:%S "
export HISTIGNORE="ls:history"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# use a colored prompt when the terminal supports it
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}[\[\033[1;34m\]\u\[\033[0m\]@\h \W]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null 2>&1; then
    if [ "$TERM" = "linux" ]; then
        if test -r "$HOME/.dircolors_tty"; then
            eval "$(dircolors -b "$HOME/.dircolors_tty")"
        else
            eval "$(dircolors -b)"
        fi
    else
        if test -r "$HOME/.dircolors"; then
            eval "$(dircolors -b "$HOME/.dircolors")"
        else
            eval "$(dircolors -b)"
        fi
    fi
    alias ls='ls --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# "$HOME/.bash_aliases", instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

# https://wiki.ubuntuusers.de/Paketverwaltung/Tipps/
apt-history() {
    local action=${1:-}
    local log
    local -a logs=()

    for log in /var/log/dpkg.log /var/log/dpkg.log.1 /var/log/dpkg.log.*.gz; do
        [[ -r $log ]] && logs+=("$log")
    done

    if ((${#logs[@]} == 0)); then
        printf 'apt-history: keine lesbaren dpkg-Protokolle gefunden\n' >&2
        return 1
    fi

    case "$action" in
    install)
        zgrep -hF -- ' install ' "${logs[@]}"
        ;;
    upgrade | remove)
        zgrep -hF -- " $action " "${logs[@]}"
        ;;
    rollback)
        if (($# != 3)); then
            printf 'Verwendung: apt-history rollback START ENDE\n' >&2
            return 2
        fi
        zgrep -hF -- ' upgrade ' "${logs[@]}" |
            grep -F -A10000000 -- "$2" |
            grep -F -B10000000 -- "$3" |
            awk '{print $4"="$5}'
        ;;
    *)
        zcat -f -- "${logs[@]}"
        ;;
    esac
}

# https://linupedia.org/opensuse/Farbe_in_der_Konsole
# Farbiger Errorlevel im Prompt
prompt_command() {
    local exit_status=${STARSHIP_CMD_STATUS:-$?}

    if ((exit_status != 0)); then
        printf '\033[93;41m[%d]\033[0m' "$exit_status"
    fi
}

### PATH
path_prepend() {
    [[ -d $1 ]] || return 0
    case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

path_prepend "$HOME/.bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
export PATH
unset -f path_prepend

export EDITOR="vim"
export TERMINAL="alacritty"
export BROWSER="brave-browser"
export READER="zathura"
export OPENER="xdg-open" # needed by lf

# https://wiki.archlinux.org/title/HiDPI
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
#export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.

# for better compatibility
export MANROFFOPT="-c"
### "bat" as manpager
if command -v batcat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif command -v vim >/dev/null 2>&1; then
    ### "vim" as manpager
    export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma|:IndentLinesDisable' -\""
fi

# LF (List File filemanager) opens at shortcut and stays at changed path after exit
LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    # shellcheck source=.config/lf/lfcd.sh
    source "$LFCD"
    bind '"\C-o":"lfcd\C-m"'
    alias lf="lfcd"
fi

# fasd - quick access to files and directories, see https://github.com/clvv/fasd/tree/master
if fasd_path=$(command -v fasd 2>/dev/null); then
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$fasd_path" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
        fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >|"$fasd_cache"
    fi
    if ! declare -F _fasd_prompt_func >/dev/null; then
        # shellcheck source=.fasd-init-bash
        source "$fasd_cache"
    fi
    unset fasd_cache
fi
unset fasd_path

### SETTING THE STARSHIP PROMPT ###
# Initialize Starship after fasd so it can preserve fasd's prompt hook and
# capture the command's real exit status before fasd runs.
if command -v starship >/dev/null 2>&1; then
    if ! declare -F starship_precmd >/dev/null; then
        eval "$(starship init bash)"
    fi
    # shellcheck disable=SC2034 # Read dynamically by starship_precmd.
    starship_precmd_user_func=prompt_command
else
    case ";${PROMPT_COMMAND:-};" in
    *';prompt_command;'*) ;;
    *) PROMPT_COMMAND="prompt_command${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
    esac
fi

# https://github.com/Canop/broot
if [ -f "$HOME/.config/broot/launcher/bash/br" ]; then
    # shellcheck source=.config/broot/launcher/bash/br
    source "$HOME/.config/broot/launcher/bash/br"
    bind -x '"\C-b": br'
fi

# use fzf for tab-completion: <tab>
#             history search: ctrl+r
#             file search:    ctrl+t
#             string search:  ctrl+f
#             cd into directory: alt+c
#             fuzzy auto completion: **
if [ -f "$HOME/.config/bash/fzf.bash" ]; then
    source "$HOME/.config/bash/fzf.bash"
fi

# terminal command 'open' shall use glow for markdown-files
# solution via mime is not perfect as another terminal window
# is opened
open() {
    if (($# != 1)); then
        printf 'Verwendung: open DATEI_ODER_URL\n' >&2
        return 2
    fi

    case "${1,,}" in
    *.md | *.markdown)
        if command -v glow >/dev/null 2>&1; then
            command glow -p -- "$1"
        else
            printf 'open: glow ist nicht installiert; verwende xdg-open\n' >&2
            command xdg-open "$@"
        fi
        ;;
    *)
        command xdg-open "$@"
        ;;
    esac
}
