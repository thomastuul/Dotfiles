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
#### Check out a clone of this repo to your home path:
```bash
cd ~
https://github.com/thomastuul/Dotfiles.git
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
with sourcing the `.bashrc` you should see the new configuration:
```bash
source .bashrc
```

#### For the best possible magnificence install following packages:
- fzf
- bat
- fasd
- broot
- lf
- bash-completion
- ripgrep
- starship  
```bash
sudo apt install fzf bat fasd lf bash-completion ripgrep
```

##### Installing `broot`, see [Personnal Azlux's repository](https://packages.azlux.fr/):  
```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
# check integrity of key:
gpg --show-keys --with-fingerprint /usr/share/keyrings/azlux-archive-keyring.gpg
# fingerprint: 98B8 24A5 FA7D 3A10 FDB2 25B7 CA54 8A0A 0312 D8E6
```


Tweaking `fzf`:  
```bash
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/	completion.bash --output completion.bash
```





