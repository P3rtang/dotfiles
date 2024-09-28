#!/bin/bash

message () {
    echo -e "\
\033[96m
---------------------------------
> $1
---------------------------------
\033[0m"
}

ask_yes_no () {
    case $3 in
        "") 
            prompt="[y/n]"
            default="echo 'expected y or n as input' && ask_yes_no $1 $2"
        ;;
        "no") 
            prompt="[y/N]"
            default="echo skipping"
        ;;
        "yes")
            prompt="[Y/n]"
            default=$2
        ;;
    esac

    read -p "$1 $prompt: " ys

    case $ys in
        [Yy]*) $2;;
        [Nn]*) echo "skipping";;
        "") $default
    esac
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
Install[debian]='apt-get install -y gdm3 sway waybar git exa kitty rofi unzip cifs-utils tmux pavucontrol curl playerctl nala sway-notification-center make cmake ninja-build gettext npm gawk bat jq openvpn network-manager-openvpn-gnome fzf ripgrep gdb libx11-dev'
Install[arch]='pacman -Sy --needed --noconfirm gdm sway swaybg waybar git exa kitty rofi firefox unzip ttf-dejavu cifs-utils tmux npm base-devel pavucontrol neovim curl playerctl fastfetch make cmake npm go gawk bat atuin jq openvpn networkmanager-openvpn fzf ripgrep golang gdb'

declare -A packageManager;
packageManager[debian]='nala install -y'
packageManager[arch]='pacman -Sy --needed --noconfirm'

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

message "INSTALL dependencies"
sudo $INSTALL

message "CONFIGURE display manager"
if [[ $(systemctl is-active ${GdmVersion[$OS_NAME]}) = "inactive" ]];then
    sudo systemctl -q enable ${GdmVersion[$OS_NAME]}
    echo "Gdm enabled"
else
    echo "Gdm already active, skipping..."
fi

message "CONFIGURE dotfiles repo"
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ init --bare
git --git-dir=$HOME/.dotfiles/ remote add origin https://github.com/p3rtang/dotfiles || true
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin
# /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f master
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull

if [[ $OS_NAME = "debian" ]];then
    if [[ -d $HOME/.packages/neovim/.git ]]; then
        message "UPDATING neovim"
        (
            cd $HOME/.packages/neovim
            make CMAKE_BUILD_TYPE=RelWithDebInfo 
            sudo make install
        )
    else
        message "INSTALLING neovim"
        rm -rf $HOME/.packages/neovim
        git clone --depth 1 https://github.com/neovim/neovim $HOME/.packages/neovim 
        (
            cd $HOME/.packages/neovim
            make CMAKE_BUILD_TYPE=RelWithDebInfo 
            sudo make install
        )
    fi
fi

message "CONFIGURE neovim"
# install packer nvim
if [[ ! -d $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
else
    (cd $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim && git pull)
fi
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

message "CONFIGURE tmux"
if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ $OS_NAME = "debian" ]] && [[ ! -L $HOME/.local/bin/go ]];then
    message "INSTALLING golang"
    mkdir -p $HOME/.packages/golang
    curl -L https://go.dev/dl/go1.22.2.linux-amd64.tar.gz -o $HOME/.packages/golang/go1.22.2.tar.gz
    tar -xzf $HOME/.packages/golang/go1.22.2.tar.gz -C $HOME/.packages/golang
    ln -s $HOME/.packages/golang/go/bin/go $HOME/.local/bin/go
fi

message "INSTALLING virtual machine dependencies"

usermod_libvirt_group () {
    sudo usermod -aG libvirt p3rtang
}

install_virt () {
    case $OS_NAME in
        "debian") sudo apt-get install -y virt-manager qemu-kvm virt-viewer ;;
        "arch") ;;
    esac

    echo ""
    ask_yes_no "Add user to the libvirt group?" usermod_libvirt_group "yes"
}

ask_yes_no "Install virtual machine dependencies?" install_virt "no"

install_samba () {
    case $OS_NAME in
        "debian") sudo apt-get -y install samba ;;
        "arch") sudo pacman -Sy --needed --noconfirm samba ;;
    esac

    sudo systemctl enable smbd && sudo systemctl start smbd
    sudo systemctl enable nmbd && sudo systemctl start nmbd

    read -p "New samba username?: " smb_username
    sudo smbpasswd -a $smb_username

    sudo systemctl restart smbd
    sudo systemctl restart nmbd
}

message "INSTALLING samba"
ask_yes_no "Set up samba?" install_samba "no"

if [[ $OS_NAME = "debian" ]] && [[ ! -L $HOME/.local/bin/zig ]];then
    message "INSTALLING zig"
    mkdir -p $HOME/.packages/zig
    curl -L https://ziglang.org/download/0.12.0/zig-linux-x86_64-0.12.0.tar.xz -o $HOME/.packages/zig/zig-0.12.tar.xz
    tar -xf $HOME/.packages/zig/zig-0.12.tar.xz -C $HOME/.packages/zig
    ln -sf $HOME/.packages/zig/zig-linux-x86_64-0.12.0/zig $HOME/.local/bin/zig
fi

message "INSTALLING gf"
if [[ ! -d $HOME/.packages/gf2 ]];then
    git clone --depth 1 https://github.com/nakst/gf.git ~/.packages/gf2/
fi
(
    cd $HOME/.packages/gf2
    git pull
    ./build.sh
    ln -sf gf2 $HOME/.local/bin/gf2
)

# on debian get fastfetch from github
if [[ $OS_NAME = "debian" ]];then
    message "INSTALLING fastfetch"
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
    message "INSTALLING swaync"
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

message "INSTALLING ble.sh"
if [[ -d $HOME/.packages/blesh ]]; then
    git -C $HOME/.packages/blesh pull
else
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git $HOME/.packages/blesh
fi
make -C $HOME/.packages/blesh install PREFIX=$HOME/.local

if [[ $OS_NAME = "debian" ]];then
    message "INSTALLING atuin"
    cd $HOME/.packages
    /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)"
    cd
fi

message "INSTALLING rofi-power-menu"
if [[ -d $HOME/.packages/rofi-power-menu ]]; then
    git -C $HOME/.packages/rofi-power-menu pull
else
    (cd $HOME/.packages/ && git clone --depth 1 https://github.com/jluttine/rofi-power-menu)
fi
sudo install $HOME/.packages/rofi-power-menu/rofi-power-menu /usr/bin/rofi-power-menu

message "INSTALLING fonts"
mkdir -p ~/.local/share/fonts
(cd .local/share/fonts && curl -O https://dtinth.github.io/comic-mono-font/ComicMono.ttf) 

curl https://use.fontawesome.com/releases/v6.3.0/fontawesome-free-6.3.0-desktop.zip -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip
unzip -qq -o ~/.local/share/fonts/fontawesome-free-6.3.0-desktop.zip -d $HOME/.local/share/fonts

message "INSTALLING wallpapers"
mkdir -p Pictures/wallpapers
curl https://wallpapercave.com/wp/wp4616344.jpg --create-dirs -o ~/Pictures/wallpapers/factorio.jpg
curl https://i.imgur.com/Jj0zk7c.jpeg --create-dirs -o ~/Pictures/wallpapers/nausicaa.jpg
