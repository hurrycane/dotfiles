#!/bin/bash

if [[ ! -e "$HOME/.config/fish" ]]; then
    ln -s $PWD/fish ~/.config/fish
    echo "Succesfully linked ~/.config/fish"
else
    echo "Not linking the fish folder since it already exists. Explore potentially deleting this folder."
    echo "If you want to link it manually try: ln -s $PWD/fish ~/.config/fish"
fi

if [[ ! -e "$HOME/.gitconfig" ]]; then
    ln -s $PWD/gitconfig ~/.gitconfig
    echo "Succesfully linked ~/.gitconfig"
else
    echo "Not linking .gitconfig file as it already exists. Explore potentially deleting this file."
    echo "If you want to link it manually try: ln -s $PWD/gitconfig ~/.gitconfig"
fi

if [[ ! -e "$HOME/.config/starship.toml" ]]; then
    ln -s $PWD/starship.toml ~/.config/starship.toml
    echo "Succesfully linked ~/.config/starship.toml"
else
    echo "Not linking $HOME/.config/starship.toml file as it already exists. Explore potentially deleting this file."
    echo "If you want to link it manually try: ln -s $PWD/starship.toml ~/.config/starship.toml"
fi

if [[ ! -e "$HOME/.vim" ]]; then
    ln -s $PWD/vim ~/.vim
    echo "Succesfully linked ~/.vim"
else
    echo "Not linking the .vim folder since it already exists. Explore potentially deleting this folder."
    echo "If you want to link it manually try: ln -s $PWD/vim ~/.vim"
fi

if [[ ! -e "$HOME/.vimrc" ]]; then
    ln -s $PWD/vimrc ~/.vimrc
    echo "Succesfully linked ~/.vimrc"
else
    echo "Not linking the .vim folder since it already exists. Explore potentially deleting this folder."
    echo "If you want to link it manually try: ln -s $PWD/vimrc ~/.vimrc"
fi
