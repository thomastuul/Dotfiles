# Dotfiles
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![shell](https://img.shields.io/badge/Shell-Bash-blue)

## Thomas's dotfiles
These dotfiles are a combination of several sources and suggestions of
* Derek Taylor [Gitlab](https://gitlab.com/dwt1/dotfiles) and [Distrotube](https://distro.tube/)
* nixCraft [30 Handy Bash Shell Aliases](https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html)
* The awesome fuzzy finder [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line)
* The next gen ls command [lsd](https://github.com/lsd-rs/lsd)
* The cross shell prompt [starship](https://starship.rs/)
* [Dracula Theme](https://github.com/dracula/dracula-theme)

## Examples

| <b>```l```<b>                                                                |
-----------------------------------------------------------------|
| <img src="https://raw.githubusercontent.com/thomastuul/Dotfiles/assets/ls-deluxe-screenshot.png" width="500px" alt="listing"> |

| <b>history search, hit <kbd>Ctrl</kbd> + <kbd>r</kbd><b>                                                                     |
-----------------------------------------------------------------|
| <img src="https://raw.githubusercontent.com/thomastuul/Dotfiles/assets/fzf-history-search.png" width="500px" alt="history search"> |

| <b>string search, hit <kbd>Ctrl</kbd> + <kbd>f</kbd><b>                                                                     |
-----------------------------------------------------------------|
| <img src="https://raw.githubusercontent.com/thomastuul/Dotfiles/assets/fzf-ripgrep-string-search.png" width="500px" alt="string search"> |

| <b>file search, hit <kbd>Ctrl</kbd> + <kbd>t</kbd><b>                                                                     |
-----------------------------------------------------------------|
| <img src="https://raw.githubusercontent.com/thomastuul/Dotfiles/assets/fzf-file-search.png" width="500px" alt="file search"> |

## Installation
> [!Note]
>
> There is no need to install the entire repository. Also you do not need to install every suggested application. Just begin with picking the `.bashrc`.
### Installing dot-files
Check out a clone of this repo to your home path:
```bash
cd ~
git clone https://github.com/thomastuul/Dotfiles.git
```
Creates the Folder `Dotfiles`.  
cd into it and delete git-files:  
```bash
cd Dotfiles
rm -rf .git
```
Copy entire content to `~`:  
```bash
cp -R .* ~
cd ~
rm -rf Dotfiles
```
with sourcing the `.bashrc` you should see the result:
```bash
source .bashrc
```

### Installing additional packages:
- fzf
- bat
- fasd
- broot
- lf
- lsd
- bash-completion
- ripgrep
- starship  
```bash
sudo apt install fzf bat fasd lf lsd bash-completion ripgrep
```

#### Installing `broot`, see [Personnal Azlux's repository](https://packages.azlux.fr/):  
```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
# check integrity of key:
gpg --show-keys --with-fingerprint /usr/share/keyrings/azlux-archive-keyring.gpg
# fingerprint: 98B8 24A5 FA7D 3A10 FDB2 25B7 CA54 8A0A 0312 D8E6
```

and finally:
```bash
sudo apt update
sudo apt install broot
```

#### Installing starship, see [Starship Cross-Shell Prompt](https://github.com/starship/starship)
```bash
# use any path you like, this is just a suggestion
cd Downloads
curl -s https://api.github.com/repos/starship/starship/releases/latest \
| grep browser_download_url \
| grep x86_64-unknown-linux-gnu \
| cut -d '"' -f 4 \
| wget -qi -
# check sha256sum:
sha256sum starship-x86_64-unknown-linux-gnu.tar.gz
# this sum must match with content of starship-x86_64-unknown-linux-gnu.tar.gz.sha256, e.g:
# 73f8e3fd9016ecaa69d29d8d6bfd5862b9005d52d4c924dbfd2b2c12de464d04
tar xvf starship-*.tar.gz
sudo mv starship /usr/local/bin/
rm starship-x86*
```


#### Tweaking `fzf`, see [fzf](https://github.com/junegunn/fzf) and [fzf-tab-completion](https://github.com/lincheney/fzf-tab-completion)
> [!Note]
>
> The debian package of fzf does not contain `completion.bash` but its git-repository yet. So let's use it...
```bash
mkdir ~/.config/fzf
cd !$
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash --output completion.bash
```

Installation of fzf-tab-completion:
```bash
git clone https://github.com/lincheney/fzf-tab-completion.git ~/.config/fzf
```

Installation of ripgrep capability, see [ripgrep-integration](https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration):
```bash
#!/usr/bin/env bash

# Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
rm -f /tmp/rg-fzf-{r,f}
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
    --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. ripgrep> ' \
    --delimiter : \
    --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
    --preview 'batcat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(vim {1} +{2})'
```
Copy the above text and save it as `rfv`
```bash
touch ~/.config/fzf/rfv
# copy above example into file...
chmod +x ~/.config/fzf/rfv
```


