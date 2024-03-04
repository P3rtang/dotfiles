#!/bin/bash

set -e

INSTALL=''
declare -A osInfo;
osInfo[/etc/debian_version]='apt-get install -y gdm3 sway waybar git exa kitty rofi unzip cifs-utils tmux pavucontrol neovim'
osInfo[/etc/arch-release]='pacman -Sy --needed --noconfirm gdm sway swaybg waybar git exa kitty rofi firefox unzip ttf-dejavu cifs-utils tmux npm base-devel pavucontrol neovim'
# osInfo[/etc/gentoo-release]=emerge
# osInfo[/etc/SuSE-release]=zypp
# osInfo[/etc/redhat-release]=yum
# osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        INSTALL=${osInfo[$f]}
    fi
done

sudo $INSTALL
sudo systemctl enable gdm

# install packer nvim
rm -r ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p $HOME/.dotfiles
cd $HOME/.dotfiles
git init --bare
git remote add origin https://github.com/p3rtang/dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f desktop
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

echo "setting up nvim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

cd
mkdir -p ~/.local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts

wget -O ~/.local/share/fonts https://use.fontawesome.com/releases/v6.3.0/fontawesome-free-6.3.0-desktop.zip
unzip fontawesome-free-6.3.0-desktop.zip

mkdir -p Pictures/wallpapers
wget -O ~/Pictures/wallpapers/factorio.jpg https://wallpapercave.com/wp/wp4616344.jpg
wget -O ~/Pictures/wallpapers/nausicaa.jpg https://i.imgur.com/Jj0zk7c.jpeg
