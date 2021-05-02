#!/bin/zsh

set -x

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

cd $HOME
git clone https://github.com/exsinod/dotfiles.git && cd dotfiles && git checkout exarch
cp -r .config/* $HOME/.config/
cp .zshrc $HOME/ && source $HOME/.zshrc
cd $HOME

# set correct system time
ntpd -qg
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

# install node, npm
nvm install stable

# configure vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sh -c "nvim +'PlugInstall --sync' +qa"
sh -c "nvim +':CocInstall coc-tsserver coc-java coc-python' +qa"

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install SdkMan
zsh <(curl -s "https://get.sdkman.io")

cd $HOME
find dotfiles -type f ! -path "dotfiles" ! -path "*.git*" ! -path "*README.md" | sed 's,dotfiles,~,g' | xargs -I{} sh -c "rm -rf {}"
rm -rf dotfiles

# Initialize dotfiles HOME
mkdir .cfg
git clone --bare https://github.com/exsinod/dotfiles.git $HOME/.cfg
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add *
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME stash
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout exarch
