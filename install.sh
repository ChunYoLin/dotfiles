mv $HOME/.vimrc $HOME/.vimrc.back
ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
mv $HOME/.inputrc $HOME/.inputrc.back
ln -s $HOME/dotfiles/.inputrc $HOME/.inputrc
mv $HOME/.tmux.conf $HOME/.tmux.conf.back
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
mv $HOME/.bashrc $HOME/.bashrc.back
ln -s $HOME/dotfiles/.bashrc $HOME/.bashrc
git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
sh $HOME/.bash_it/install.sh
