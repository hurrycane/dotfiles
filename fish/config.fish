# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH

# status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

set fish_greeting ""

starship init fish | source
