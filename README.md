# bin

This repo conatins my personal linux scripts, and dotfiles.
to symlink them into the homedirectory, I use stow.

##i3
This i3 setup has a few dependencies:
  * feh is requiered to set your background
  * termite is required (autostart in the workspaces)
  * compton is required due to oppacity
  * scrot is requered for a semi-transparent i3-lock
Furthermore i remapped my CapsLock to super4 (windows-key in most cases). It is kind of buggy since CapsLock is NOT available at the moment.

## vim
In order to use my .vimrc, vundle is required. To setup Vundle you can use this command: 'git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'.
After vundle is installed (you probaly just have to clone the repo), you can use the ':PluginInstall' command to install all required plugins.
To acquire autocompletion in vim, you have to setup [YouCompleteMe](https://github.com/Valloric/YouCompleteMe#mac-os-x-super-quick-installation). The easiest way to do so, is 'python ~/.vim/bundle/YouCompleteMe/install.py'.

## toggleMonitor    
Since I have written this, only for my environment, you have to change the names of the videoport's. You can indetify them with the xrandr command.

