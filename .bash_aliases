## -----------------------------------------------------------------------------------------
## Created by Vivek Gite <vivek@nixcraft.com>
## See for more info: http://www.cyberciti.biz/tips/linux-unix-osx-bash-shell-aliases.html
## Note: I work a lot with Amazon EC2/CDN/Akamai/Server Backups etc so source code of those
## scripts not included in this file. YMMV.
## -----------------------------------------------------------------------------------------

if command -v lsd &> /dev/null; then
    if [ "$TERM" != "linux" ]; then
        alias ls='lsd --group-directories-first'
    else
        alias ls='lsd --group-directories-first --icon never'
    fi
fi

if [ -f $HOME/.config/bash/ls.aliases.sh ]; then
    source $HOME/.config/bash/ls.aliases.sh
fi

alias ll='ls -l'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias bc='bc -l'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias firewall=iptlist
alias header='curl -I'
alias headerc='curl -I --compress'
alias iftop='iftop -i eth1'
alias tcpdump='tcpdump -i eth1'
alias ethtool='ethtool eth1'
alias iwconfig='iwconfig wlan0'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
alias top='atop'
alias music='ncmpc'
alias musicpp='ncmpcpp'
alias gs='git status'
alias gd='git diff'
alias cat='batcat'
alias fd='fdfind'
alias cool=$HOME/.local/bin/cool
alias yt="yt-dlp --embed-metadata -i"
alias yta="yt -x -f bestaudio/best"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias ip="ip -color=auto"
alias feh="feh --conversion-timeout 5"
alias ncdu="ncdu --color dark"
alias git-tree="git ls-tree --full-tree -r HEAD"
alias tree="ls --tree"
alias lt="ls --tree"
