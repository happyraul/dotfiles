# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=10000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/raul/.zshrc'

# End of lines added by compinstall

fpath=("$HOME/.zprompts" "$fpath[@]")
autoload -Uz compinit promptinit
compinit
promptinit

prompt raul

# enable reverse/forward search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# env
export EDITOR='vim'
export BROWSER='firefox'
export WORKON_HOME='~/.virtualenvs'

# store pass as selection
export PASSWORD_STORE_X_SELECTION=primary

# aliases

# manage
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

alias cg='git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

# directory
alias ...='cd ../../'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias md='mkdir -p'
alias rd='rmdir'

# git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcm='git checkout master'
alias gd='git diff'
alias gfo='git fetch origin'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glg='glola'
alias gra='git remote add'
alias grv='git remote -v'
alias gst='git status'

source /usr/bin/virtualenvwrapper.sh

ci() {
  project=${PWD##*/}
  surf "https://app.circleci.com/pipelines/github/stylight/$project"
}

if [[ ! $DISPLAY ]]; then
  startx
fi

