alias cd..='cd ..'
alias jobs='jobs -l'
alias less='less -R'
alias ll='gls -AFGHhl --color=auto'
alias ls='gls -FGH --color=auto'
alias prettify_json='python -mjson.tool'
alias reload='source ~/.bashrc'
alias whitespace='find . -not \( -name .svn -prune -o -name .git -prune \) -type f -print0 | xargs -0 sed -i "" -E "s/[[:space:]]*$//"'

alias o='open . &'
alias p='cd ~/Projects'
alias gs='git status'
alias load_py='source /usr/local/bin/virtualenvwrapper.sh'
alias p='python'

alias fetch="git co master && git fetch && git pull --rebase"
alias docker_clean='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'
alias docker_stop='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias s="cd ~/Projects"
