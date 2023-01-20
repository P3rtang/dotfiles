#!/bin/bash
#
$HOME=$(pwd)
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

sudo pacman -S gdm sway swaybg waybar git lsd kitty rofi firefox unzip ttf-dejavu cifs-utils tmux\
    npm base-devel
sudo systemctl enable gdm
mkdir .dotfiles
git init --bare $HOME/.dotfiles

gitbare config --local status.showUntrackedFiles no
gitbare clone https://github.com/p3rtang/dotfiles
cd .dotfiles
fp -r . ~
cd
mkdir .local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts
cd .local/share/fonts
unzip fontawesome-free-5.15.4-desktop.zip
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
cd ~
mkdir .aur
cd .aur
git clone https://aur.archlinux.org/swaync.git
cd swaync
makepkg -si
git clone https://aur.archlinux.org/fastfetch.git
cd fastfetch
makepkg -si
