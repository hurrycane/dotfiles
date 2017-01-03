export INPUTRC="~/.inputrc"
export EDITOR=`which vim`
export PROMPT_COMMAND="history -a"
export HISTSIZE=5000

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[[ -s "$HOME/.aliases.sh" ]] && source "$HOME/.aliases.sh"

# Bash completion (usually includes git completion)
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# Ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# Autofix typos
shopt -s cdspell

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make Bash append rather than overwrite the history on disk.
shopt -s histappend

# Make 'less' more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

function parse_git_deleted {
  [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
}
function parse_git_added {
  [[ $(git status 2> /dev/null | grep "Untracked files:") != "" ]] && echo '+'
}
function parse_git_modified {
  [[ $(git status 2> /dev/null | grep modified:) != "" ]] && echo "*"
}
function parse_git_dirty {
  # [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "☠"
  echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)"
}
function parse_git_branch {
  echo "$(parse_git_dirty)$(__git_ps1 '%s')"
}

force_color_prompt=yes

export PATH="/usr/local/bin":$PATH
# enable color support of ls and also add handy aliases
if [ -x /usr/local/opt/coreutils/libexec/gnubin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
export LSCOLORS='Exfxcxdxbxegedabagacad'

PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\H \[$(tput setaf 4)\]\w\[\e[31;1m\] \$(parse_git_branch)\[\e[0m\]\n\[$(tput bold)\]\[$(tput setaf 1)\]\[$(tput sgr0)\]> "

unset color_prompt

if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi


PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
eval `dircolors /Users/bogdan/Projects/dotfiles/dircolors-solarized/dircolors.256dark`
