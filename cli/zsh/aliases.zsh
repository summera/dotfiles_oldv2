# Aliases in this file are bash and zsh compatible

# PS
alias psa="ps aux"
alias psg="ps aux | grep "
alias psr='ps aux | grep ruby'

# mimic vim functions
alias :q='exit'

# zsh profile editing
alias ze='vim ~/.zshrc'
alias zr='source ~/.zshrc'

# Git Aliases
alias gpsh='git push -u origin `git rev-parse --abbrev-ref HEAD`'
alias grb='git recent-branches'
alias groot='cd $(git root)'

# Common shell functions
alias less='less -r'
alias tf='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files
alias cl='clear'
alias gz='tar -zcvf'
alias ka9='killall -9'
alias k9='kill -9'
alias ..='cd ..'

# Ruby
alias be='bundle exec'

# Vim
alias v='nvim'

alias rm='rmtrash'
alias rmdir='rmdirtrash'
