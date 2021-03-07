#!/bin/bash
declare -a configFiles=('.zprofile' '.zshrc' '.shell_aliases' '.vimrc' '.tmux.conf' '.tmux.reset.conf')

if command -v apt -v &> /dev/null; then
   pkgMgr=apt
else
   echo "no"
   exit 0
fi

# check if tmux is installed
if ! command -v tmux -V &> /dev/null; then
   read -p "tmux is not installed, would you like to install? (y/n) " response
   if [ "$response" = "y" ]; then
      echo "updating package lists"
      sudo $pkgMgr update
      echo "Installing tmux"
      sudo $pkgMgr install tmux
      read -p "Would you also like to install tmux plugin manager? (y/n) " response
      if [ "$response" = "y" ]; then
         TPMDIR=".tmux/plugins/tpm/"
         echo "creating $HOME/$TPMDIR"
         mkdir -p $HOME/$TPMDIR
         echo "installing tpm"
         if ! git clone https://github.com/tmux-plugins/tpm $HOME/$TPMDIR
         then
            echo >&2 "installation of tpm failed. Exiting"
            rm -rf $HOME/.tmux
            exit 1
         else
            echo "tpm successfully installed"
         fi
      elif [ "$response" = "n" ]; then
         echo "Skipping installation of tpm"
      else
         "Invalid response. Skipping installation of tpm"
      fi
   elif [ "$response" = "n" ]; then
      echo "Skipping installation of tmux"
   else
      "Invalid response. Skipping installation of tmux"
   fi
else
   echo "tmux already installed"
fi

# check if zsh is installed
if ! command -v zsh --version &> /dev/null; then
   read -p "zsh is not installed, would you like to install? (y/n) " response
   if [ "$response" = "y" ]; then
      echo "updating package lists"
      sudo $pkgMgr update
      echo "Installing zsh"
      sudo $pkgMgr install zsh
      read -p "Would you also like to install ohmyzsh? (y/n) " response
      if [ "$response" = "y" ]; then
         echo "installing ohmyzsh"
         sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      elif [ "$response" = "n" ]; then
         echo "Skipping installation of ohmyzsh"
      else
         "Invalid response. Skipping installation of ohmyzsh"
      fi
   elif [ "$response" = "n" ]; then
      echo "Skipping installation of zsh"
   else
      "Invalid response. Skipping installation of zsh"
   fi
else
   echo "zsh already installed"
fi
   
if [ "$#" -gt 1 ]; then
   echo >&2 "Usage: ./install.sh [options]"
   echo >&2 "./install.sh -h for more information"
   exit 0
fi

if [ "$1" = "-h" ]; then
   echo "-h            Print Help (this message) and exit"
   echo "-f            Force"
   exit 0
fi

for file in "${configFiles[@]}"; do
   if [[ -f "$HOME/$file" && "$1" != "-f" ]] ; then
      read -p "'$file' already exists. Are you sure you want to overwrite (y/n)? " response
      if [ "$response" = "y" ]; then
         echo "installing '$file' into $HOME"
         cp $file $HOME
      elif [ "$response" = "n" ]; then
         echo "Skipping installation of '$file'"
      else
         "Invalid response. Skipping installation of '$file'"
      fi
   else
      echo "installing '$file' into $HOME"
      cp $file $HOME
   fi
done
