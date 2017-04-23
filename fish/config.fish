# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/sbin $PATH

# Set rbenv path end RBENV_SHELL shell type.
setenv RBENV_SHELL fish
setenv PATH $HOME/.rbenv/shims $PATH
# Also load rbenv fish completions
source '/usr/local/Cellar/rbenv/1.1.0/completions/rbenv.fish'
