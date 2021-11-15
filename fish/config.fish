# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/sbin $PATH

set fish_greeting ""

set -x GOPATH $HOME/.golang:$GOPATH

set -x PATH $HOME/.golang/bin $PATH

set -x PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH

set -gx PATH "$HOME/.cargo/bin" $PATH;

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bogdan/Projects/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/Users/bogdan/Projects/google-cloud-sdk/path.fish.inc'; else; . '/Users/bogdan/Projects/google-cloud-sdk/path.fish.inc'; end; end
set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths

# openssl flags for the compilers to find
set -gx LDFLAGS "-L/usr/local/opt/openssl/lib"
set -gx CPPFLAGS "-I/usr/local/opt/openssl/include"

status --is-interactive; and source (rbenv init -|psub)
