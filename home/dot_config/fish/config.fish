# Set default editor
set -x EDITOR (which vim)
# Set paths needed for homebrew
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
set -x PATH /opt/homebrew/lib $PATH

set fish_greeting ""

if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end

if test -d $HOME/Downloads/hyperpodeks/bin
    fish_add_path $HOME/Downloads/hyperpodeks/bin
end

if test -d /opt/homebrew/opt/llvm/bin
    fish_add_path /opt/homebrew/opt/llvm/bin
    set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
end

# Guarded so a machine without these installed still gets a working shell.
if command -q starship
    starship init fish | source
end

if command -q direnv
    direnv hook fish | source
end

# uv
if test -f $HOME/.local/bin/env.fish
    source $HOME/.local/bin/env.fish
end

# --- CLI stack -------------------------------------------------------------
# eza, bat, fd, ripgrep, zoxide, fzf, atuin, delta, dust.
# Everything is guarded, so a machine missing one of these still boots a shell.
# delta needs no init here; gitconfig wires it up as git's pager.

# eza replaces ls. cat/du/find/grep are deliberately left alone -- bat, dust,
# fd and rg take incompatible flags, so they get invoked by name.
if command -q eza
    alias ls 'eza --group-directories-first --icons=auto'
    alias ll 'eza -l --git --group-directories-first --icons=auto'
    alias la 'eza -la --git --group-directories-first --icons=auto'
    alias lt 'eza --tree --level=2 --icons=auto'
end

if command -q bat
    set -gx BAT_THEME "Solarized (dark)"
    # Colorized man pages
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c
end

# Let fzf walk the tree with fd: respects .gitignore and is much faster.
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

if command -q zoxide
    zoxide init fish | source
end

# Nothing to do about /opt/homebrew/share/fish/vendor_completions.d -- fish
# already carries it in $fish_complete_path because fish itself is installed
# under /opt/homebrew, so brew-installed completions are picked up for free.

# fzf must init BEFORE atuin: both bind ctrl-r and the last one loaded wins.
# This leaves fzf owning ctrl-t (files) and alt-c (cd), atuin owning ctrl-r.
if command -q fzf
    if command -q bat
        set -gx FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}'"
    end
    fzf --fish | source
end

# --disable-up-arrow keeps fish's own prefix-search on up-arrow, which is
# better than atuin's for the last few commands. ctrl-r is still atuin.
if command -q atuin
    atuin init fish --disable-up-arrow | source
end
