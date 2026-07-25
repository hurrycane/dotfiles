# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
set -x PATH /opt/homebrew/lib $PATH

set fish_greeting ""

fish_add_path /Users/bogdan/Downloads/hyperpodeks/bin

fish_add_path /opt/homebrew/opt/llvm/bin

set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

starship init fish | source
direnv hook fish | source

source $HOME/.local/bin/env.fish
