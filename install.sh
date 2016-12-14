ln -s ./.vimrc $HOME/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
ln -s ./.inputrc $HOME/.inputrc
ln -s ./.tmux.conf $HOME/.tmux.conf
ln -s ./.bashrc $HOME/.bashrc
git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
sh $HOME/.bash_it/install.sh
