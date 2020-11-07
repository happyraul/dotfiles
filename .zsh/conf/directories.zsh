# Changing/making/removing directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Make cd push the old directory onto the directory stack.
setopt auto_pushd

# Don’t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# Exchanges the meanings of ‘+’ and ‘-’ when used with a number to specify a 
# directory in the stack.
setopt pushd_minus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'

alias md='mkdir -p'
alias rd='rmdir'

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

