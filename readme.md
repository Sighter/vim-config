Instructions:
    
Clone the repo and link your vimrc

    cd
    git clone git://github.com/Sighter/vim-config.git .vim
    ~/.vim/linkdown.sh
    cd .vim
    git submodule init
    git submodule update


The vimrc is framebuffer aware so check, whether you have set the
proper TERM variable in the fb. (must be "linux")
