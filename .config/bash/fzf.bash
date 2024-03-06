# Setup fzf
# dpkg-package for fzf is not setting up all features of https://github.com/junegunn/fzf
# and its install-script, so setup of features is done manually here

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md
if command -v fzf &> /dev/null; then
    # https://github.com/junegunn/fzf#tips
    export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --info=inline --border --margin=1 --padding=1\
                             --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9\
                             --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9\
                             --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6\
                             --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
    if [ -f "$HOME/.config/fzf/rfv" ]; then
        bind -x '"\C-f": $HOME/.config/fzf/rfv'
    fi
    # use fzf for tab completion, see https://github.com/lincheney/fzf-tab-completion/tree/master#bash
    if [ -f "$HOME/.config/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh" ]; then
        source "$HOME/.config/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh"
        bind -x '"\t": fzf_bash_completion'
    fi
    # enable fzf keybindings
    if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
        source /usr/share/doc/fzf/examples/key-bindings.bash
        # Preview file content using bat (https://github.com/sharkdp/bat)
        # see https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
        export FZF_CTRL_T_OPTS="
            --preview 'batcat -n --color=always {}'
            --bind 'ctrl-/:change-preview-window(down|hidden|)'"
        # CTRL-/ to toggle small preview window to see the full command
        # CTRL-Y to copy the command into clipboard using pbcopy
        export FZF_CTRL_R_OPTS="
            --preview 'echo {}' --preview-window up:3:hidden:wrap
            --bind 'ctrl-/:toggle-preview'
            --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
            --color header:italic
            --header 'Press CTRL-Y to copy command into clipboard'"
        # ALT+C for cd into directory
        # Print tree structure in the preview window
        export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
    fi
    # enable fuzzy auto-completion
    if [ -f "$HOME/.config/fzf/completion.bash" ]; then
        source "$HOME/.config/fzf/completion.bash"
    fi
fi
