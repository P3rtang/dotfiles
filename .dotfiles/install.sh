#!/bin/bash
#
$HOME=$(pwd)

sudo pacman -Syu
sudo pacman -S --needed --noconfirm gdm sway swaybg waybar git lsd kitty rofi firefox unzip ttf-dejavu cifs-utils tmux\
    npm base-devel pavucontrol
sudo systemctl enable gdm

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p $HOME/.packages

cd $HOME/.packages
git clone https://aur.archlinux.org/swaync.git
cd swaync
makepkg -si --noconfirm

cd $HOME/.packages
git clone https://aur.archlinux.org/fastfetch.git
cd fastfetch
makepkg -si --noconfirm

cd $HOME/.packages
git clone https://aur.archlinux.org/wlr-randr.git
cd wlr-randr
makepkg -si --noconfirm

cd $HOME/.packages
git clone https://github.com/p3rtang/swaymenu
cd swaymenu
make install


mkdir -p $HOME/.dotfiles
cd $HOME/.dotfiles
git init --bare
git remote add origin https://github.com/p3rtang/dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f master
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

echo "setting up nvim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

cd $HOME
mkdir -p .local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts

cd $HOME/.local/share/fonts
wget https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-desktop.zip
unzip fontawesome-free-5.15.4-desktop.zip

cd $HOME
mkdir -p Pictures/wallpapers
wget -O ~/Pictures/wallpapers/factorio.jpg https://wallpapercave.com/wp/wp4616344.jpg
wget -O ~/Pictures/wallpapers/nausicaa.jpg http://www.wallpapersin4k.org/wp-content/uploads/2017/04/Nausicaa-Wallpaper-10.jpg
