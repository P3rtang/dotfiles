#!/bin/bash

message () {
    echo -e "\
\033[96m
---------------------------------
> $1 $2
---------------------------------
\033[0m"
}

set -e

declare -A osInfo;
osInfo[/etc/debian_version]=debian
osInfo[/etc/arch-release]=arch
# osInfo[/etc/gentoo-release]=emerge
# osInfo[/etc/SuSE-release]=zypp
# osInfo[/etc/redhat-release]=yum
# osInfo[/etc/alpine-release]=apk

declare -A GdmVersion;
GdmVersion[debian]='gdm3'
GdmVersion[arch]='gdm'

declare -A Install;
Install[debian]='apt-get install -y gdm3 sway waybar git exa kitty rofi unzip cifs-utils tmux pavucontrol curl playerctl nala sway-notification-center make cmake ninja-build gettext npm golang gawk bat jq openvpn network-manager-openvpn-gnome fzf'
Install[arch]='pacman -Sy --needed --noconfirm gdm sway swaybg waybar git exa kitty rofi firefox unzip ttf-dejavu cifs-utils tmux npm base-devel pavucontrol neovim curl playerctl fastfetch make cmake npm go gawk bat atuin jq openvpn networkmanager-openvpn fzf'

INSTALL=''
OS_NAME=''
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        OS_NAME=${osInfo[$f]}
        INSTALL=${Install[$OS_NAME]}
        GDM_VERSION=
    fi
done

message "INSTALL" "dependencies"
sudo $INSTALL

message "CONFIGURE" "display manager"
if [[ $(systemctl is-active ${GdmVersion[$OS_NAME]}) = "inactive" ]];then
    sudo systemctl -q enable ${GdmVersion[$OS_NAME]}
    echo "Gdm enabled"
else
    echo "Gdm already active, skipping..."
fi

message "CONFIGURE" "dotfiles repo"
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ init --bare
git --git-dir=$HOME/.dotfiles/ remote add origin https://github.com/p3rtang/dotfiles || true
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f master
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull

if [[ $OS_NAME = "debian" ]];then
    if [[ -d $HOME/.packages/neovim/.git ]]; then
        message "UPDATE" "neovim"
        cd $HOME/.packages/neovim
        make CMAKE_BUILD_TYPE=RelWithDebInfo 
        sudo make install
        cd
    else
        message "INSTALL" "neovim"
        rm -rf $HOME/.packages/neovim
        git clone --depth 1 https://github.com/neovim/neovim $HOME/.packages/neovim 
        cd $HOME/.packages/neovim
        make CMAKE_BUILD_TYPE=RelWithDebInfo 
        sudo make install
        cd
    fi
fi

message "CONFIGURE" "neovim"
# install packer nvim
rm -rf $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

if [[ $OS_NAME = "debian" ]];then
    message "INSTALLING" "golang"
    mkdir -p $HOME/.packages/golang
    curl -L https://go.dev/dl/go1.22.2.linux-amd64.tar.gz -o $HOME/.packages/golang/go1.22.2.tar.gz
    tar -xzf $HOME/.packages/golang/go1.22.2.tar.gz -C $HOME/.packages/golang
    ln -s $HOME/.packages/golang/go/bin/go $HOME/.local/bin/go
fi

cd
# on debian get fastfetch from github
if [[ $OS_NAME = "debian" ]];then
    message "INSTALLING" "fastfetch"
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
    message "INSTALLING" "swaync"
    if [[ -f $HOME/.packages/swaync/PKGBUILD ]];then
        (cd $HOME/.packages/swaync && git pull)
    elif [[ -d $HOME/.packages/swaync ]];then
        rm -rf $HOME/.packages/swaync
        git clone https://aur.archlinux.org/swaync.git ~/.packages/swaync/
    else
        git clone https://aur.archlinux.org/swaync.git ~/.packages/swaync/
    fi
    (cd $HOME/.packages/swaync && makepkg -si --noconfirm ~/.packages/swaync/PKGBUILD)
fi

message "INSTALLING" "ble.sh"
if [[ -d $HOME/.packages/blesh ]]; then
    git -C $HOME/.packages/blesh pull
else
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git $HOME/.packages/blesh
fi
make -C $HOME/.packages/blesh install PREFIX=$HOME/.local

if [[ $OS_NAME = "debian" ]];then
    message "INSTALLING" "atuin"
    cd $HOME/.packages
    /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"
    cd
fi

message "INSTALLING" "rofi-power-menu"
if [[ -d $HOME/.packages/rofi-power-menu ]]; then
    git -C $HOME/.packages/rofi-power-menu pull
else
    (cd $HOME/.packages/ && git clone --depth 1 https://github.com/jluttine/rofi-power-menu)
fi
sudo install $HOME/.packages/rofi-power-menu/rofi-power-menu /usr/bin/rofi-power-menu

message "INSTALLING" "fonts"
mkdir -p ~/.local/share/fonts
(cd .local/share/fonts && curl -O https://dtinth.github.io/comic-mono-font/ComicMono.ttf) 

curl https://use.fontawesome.com/releases/v6.3.0/fontawesome-free-6.3.0-desktop.zip -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip
unzip -qq -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip -d $HOME/.local/share/fonts

message "INSTALLING" "wallpapers"
mkdir -p Pictures/wallpapers
curl https://wallpapercave.com/wp/wp4616344.jpg --create-dirs -o ~/Pictures/wallpapers/factorio.jpg
curl https://i.imgur.com/Jj0zk7c.jpeg --create-dirs -o ~/Pictures/wallpapers/nausicaa.jpg
