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
rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p $HOME/.dotfiles
cd $HOME/.dotfiles
git init --bare
git remote add origin https://github.com/p3rtang/dotfiles || true
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f desktop
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

echo "setting up nvim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

cd
mkdir -p ~/.local/share/fonts
wget https://dtinth.github.io/comic-mono-font/ComicMono.ttf -P .local/share/fonts

curl https://use.fontawesome.com/releases/v6.3.0/fontawesome-free-6.3.0-desktop.zip -o ~/.local/share/fonts
unzip ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip $HOME/.local/share/fonts

mkdir -p Pictures/wallpapers
curl https://wallpapercave.com/wp/wp4616344.jpg --create-dirs -o ~/Pictures/wallpapers/factorio.jpg
curl https://i.imgur.com/Jj0zk7c.jpeg --create-dirs -o ~/Pictures/wallpapers/nausicaa.jpg
