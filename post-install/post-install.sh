#!/usr/bin/bash

# ***************************************************************************
# * SuperConsole Post-Install Configuration Script                          *
# * Copyright (C) 2020  Alex Chmykhalo <alex.chmykhalo@gmail.com>           *
# *                                                                         *
# * SuperConsole is a software collection based on ConEmu, MSYS2, mintty,   *
# * Zsh, Git for Windows, grml-zsh-config, antigen and agkozak-zsh-theme    *
# * projects customized and configured for everyday use.                    *
# ***************************************************************************

# Dir where script is located.
# Script should be placed inside of
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo Update all...
pacman --noprogress -Suy --noconfir

echo Settings for pacman: git-for-windows repo, display options, disable 32-bit mingw repo ...
cp /etc/pacman.conf /etc/pacman.conf.old
cp $SCRIPT_DIR/pacman.conf /etc

echo Add key for git-for-windows - https://github.com/git-for-windows/git/wiki/Install-inside-MSYS2-proper ...
#curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/master/git-for-windows-keyring/git-for-windows.gpg | pacman-key --add - && pacman-key --lsign-key 1A9F3986
curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/HEAD/git-for-windows-keyring/git-for-windows.gpg | pacman-key --add - && pacman-key --lsign-key 3B6D86A1BA7701CD0F23AED888138B9E1A9F3986

echo Update all...
pacman --noprogress -Suy --noconfirm
echo Fetch all repos and install essentials utils, settings and git for windows...
pacman --needed --noprogress -S --noconfirm colormake colordiff dialog grml-zsh-config man-db nano nano-syntax-highlighting openssh pkgfile patch procps-ng zip unzip vim winln winpty zsh mingw-w64-x86_64-adobe-source-code-pro-fonts mingw-w64-x86_64-git mingw-w64-x86_64-git-credential-manager mingw-w64-x86_64-git-doc-man mingw-w64-x86_64-git-lfs mingw-w64-x86_64-git-sizer mingw-w64-x86_64-wintoast mingw-w64-x86_64-zstd

echo Fetch info to use with command-not-found handler ...
pkgfile --update

echo Enable nano colored syntax highligting and custom settings ...
cp $SCRIPT_DIR/.nanorc $HOME

echo ConEmu configured to search SourceCodePro-Regular font in root dir - we will use installed one with MSYS2....
winln /mingw64/share/fonts/adobe-source-code-pro/SourceCodePro-Regular.otf $MSYS2_DIR/SourceCodePro.otf

echo Set custom zsh configuration...
cp $SCRIPT_DIR/.zshrc $HOME
cp $SCRIPT_DIR/.zshrc.pre $HOME

echo Copy configuration for Mintty...
cp $SCRIPT_DIR/.minttyrc $HOME

echo .ssh folder is necessary to avoid ssh-agent plugin warnings...
mkdir /home/user/.ssh

echo Enable credentials manager for git...
cp $SCRIPT_DIR/.gitconfig $HOME

echo Remove cached pacman packages...
pacman -Scc --noconfirm
