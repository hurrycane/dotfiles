# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH

status --is-interactive; and source (rbenv init -|psub)

set fish_greeting ""

set -x PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Projects/misc/google-cloud-sdk/path.fish.inc" ]; . "$HOME/Projects/misc/google-cloud-sdk/path.fish.inc"; end
fish_add_path /opt/homebrew/opt/node@14/bin
