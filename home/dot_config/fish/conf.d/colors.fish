# Solarized-ish fish colors.
#
# These used to live in fish/fish_variables as universal variables, which fish
# rewrites in place -- when ~/.config/fish was a symlink into the dotfiles repo,
# fish 4.3's key-binding migration rewrote that file and dropped every one of
# these. Setting them globally from config keeps them under version control and
# out of reach of fish's own bookkeeping.

set -g fish_color_autosuggestion 555 brblack
set -g fish_color_cancel -r
set -g fish_color_command blue
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end green
set -g fish_color_error brred
set -g fish_color_escape brcyan
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_host_remote yellow
set -g fish_color_normal normal
set -g fish_color_operator brcyan
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection cyan --bold
set -g fish_color_search_match white --background=brblack
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_status red
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D yellow -i
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_selected_background -r
