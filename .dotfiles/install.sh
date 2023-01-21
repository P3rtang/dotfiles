#!/bin/bash
#
$HOME=$(pwd)

sudo pacman -S --needed gdm sway swaybg waybar git lsd kitty rofi firefox unzip ttf-dejavu cifs-utils tmux\
    npm base-devel pavucontrol
sudo systemctl enable gdm

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p .aur
cd .aur
git clone https://aur.archlinux.org/swaync.git
cd swaync
makepkg -si
git clone https://aur.archlinux.org/fastfetch.git
cd fastfetch
makepkg -si

mkdir -p .dotfiles
cd .dotfiles
git init --bare
git remote add origin https://github.com/p3rtang/dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f master
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

wget -O $HOME/.local/bin/swaymenu https://github.com/P3rtang/swaymenu/releases/download/alpha/swaymenu
chmod +x $HOME/.local/bin/swaymenu

cd $HOME
mkdir -p .local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts
cd .local/share/fonts
unzip fontawesome-free-5.15.4-desktop.zip
cd ~
mkdir -p Pictures/wallpapers
wget -O ~/Pictures/wallpapers/factorio.jpg https://wallpapercave.com/wp/wp4616344.jpg
