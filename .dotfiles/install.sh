#!/bin/bash

set -e

declare -A osInfo;
osInfo[/etc/debian_version]=debian
osInfo[/etc/arch-release]=arch
# osInfo[/etc/gentoo-release]=emerge
# osInfo[/etc/SuSE-release]=zypp
# osInfo[/etc/redhat-release]=yum
# osInfo[/etc/alpine-release]=apk

declare -A Install;
Install[debian]='apt-get install -y gdm3 sway waybar git exa kitty rofi unzip cifs-utils tmux pavucontrol curl playerctl nala sway-notification-center make cmake ninja-build gettext npm'
Install[arch]='pacman -Sy --needed --noconfirm gdm sway swaybg waybar git exa kitty rofi firefox unzip ttf-dejavu cifs-utils tmux npm base-devel pavucontrol neovim curl playerctl fastfetch make cmake npm'

INSTALL=''
OS_NAME=''
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        OS_NAME=${osInfo[$f]}
        INSTALL=${Install[$OS_NAME]}
    fi
done
echo $INSTALL

sudo $INSTALL
sudo systemctl enable gdm

mkdir -p $HOME/.dotfiles
cd $HOME/.dotfiles
git init --bare
git remote add origin https://github.com/p3rtang/dotfiles || true
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
# /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f desktop
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

if [[ $OS_NAME = "debian" ]];then
    echo "---------------------------------"
    echo "> INSTALL neovim"
    echo "---------------------------------"
    rm -rf $HOME/.packages/neovim
    git clone --depth 1 https://github.com/neovim/neovim $HOME/.packages/neovim 
    cd $HOME/.packages/neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo 
    sudo make install
    cd
fi

echo "---------------------------------"
echo "> CONFIGURE neovim"
echo "---------------------------------"
# install packer nvim
rm -rf $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

cd
# on debian get fastfetch from github
if [[ $OS_NAME = "debian" ]];then
    echo "---------------------------------"
    echo "> INSTALLING fastfetch"
    echo "---------------------------------"
    curl -L --create-dirs -o $HOME/.packages/fastfetch/fastfetch.deb \
    $(curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
        | jq -r '.assets[] | select(.name=="fastfetch-linux-amd64.deb").browser_download_url' \
    )
    sudo apt-get install -y ~/.packages/fastfetch/fastfetch.deb
fi

# on arch get swaync from aur
if [[ $OS_NAME = "arch" ]];then
    echo "---------------------------------"
    echo "> INSTALLING swaync"
    echo "---------------------------------"
    git clone https://aur.archlinux.org/swaync.git ~/.packages
    makepkg -si ~/.packages/swaync/PKGBUILD
fi

echo "---------------------------------"
echo "> INSTALLING fonts"
echo "---------------------------------"
mkdir -p ~/.local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts

curl https://use.fontawesome.com/releases/v6.3.0/fontawesome-free-6.3.0-desktop.zip -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip
unzip -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip -d $HOME/.local/share/fonts

echo "---------------------------------"
echo "> INSTALLING wallpapers"
echo "---------------------------------"
mkdir -p Pictures/wallpapers
curl https://wallpapercave.com/wp/wp4616344.jpg --create-dirs -o ~/Pictures/wallpapers/factorio.jpg
curl https://i.imgur.com/Jj0zk7c.jpeg --create-dirs -o ~/Pictures/wallpapers/nausicaa.jpg
