# install Packer for nvim package management
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# install rust toolchain LSP
sudo pacman -S rust-analyzer
rustup component add rust-analyzer
