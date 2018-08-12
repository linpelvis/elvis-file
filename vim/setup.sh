#!/bin/bash

dir=`dirname $0`
export dir=`cd $dir; pwd`
export time=`date +"%Y%m%d%H%M%S"`

VIMRC=${dir}/vimrc

#############vim##############
rm -rf ~/tmp/vim
if [ ! -d ~/vim/ ]
then
    mkdir -p $HOME/vim/
    mkdir -p ~/tmp/vim && cd ~/tmp/vim
    git clone https://github.com/vim/vim.git
    cd ~/tmp/vim/vim
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp=yes \
                --enable-pythoninterp=yes \
                --with-python-config-dir=/usr/lib/python2.7/config \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-gui=gtk2 \
                --enable-cscope \
                --prefix=/$HOME/vim 1>/dev/null
    make 1>/dev/null
    make install 1>/dev/null
    rm -rf ~/tmp/vim

    rm ~/.vimrc 2>/dev/null || true
    cd ~ && ln -s $VIMRC .vimrc
    cd $dir
fi
##############################

###########bundle#############
if [ ! -d ~/.vim/bundle ]
then
    mkdir -p ~/.vim/bundle && cd ~/.vim/
    #we just use `~/.vim/bundle` as installation directory
    bash ${dir}/bundle_installer.sh ~/.vim/bundle 1>/dev/null
    cd $dir
fi
##############################

###########plugin#############
# dein update may not install plugin, try several times
for ((i=1;i<5;i++))
do
    #$HOME/vim/bin/vim +'call dein#install()' +qall
    $HOME/vim/bin/vim +'call dein#update()' +qall
    if [ -d ~/.vim/bundle//repos//github.com/bladechen/ ];then
        break
    fi
done
##############################

########YouCompleteMe#########
# need install cmake
cd ~/.vim/bundle/repos//github.com/Valloric/YouCompleteMe/ 2>/dev/null || true
ycm_install=`find . -name "ycm_core.so"|wc -l | sed 's/[ ][ ]*//g'`
echo $ycm_install
if [ "$ycm_install" == "0" ]
then
     ./install.py --clang-complete --go-completer
fi
cd $dir

cp ycm_extra_conf.py ~/.ycm_extra_conf.py
##############################

