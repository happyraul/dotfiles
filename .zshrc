# Lines configured by zsh-newuser-install

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/raul/.zshrc'

# End of lines added by compinstall
source ~/.zsh/zsh.sh

fpath=("$HOME/.zprompts" "$fpath[@]")
autoload -Uz compinit promptinit
compinit
promptinit

prompt raul

# enable reverse/forward search
#bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# env
export EDITOR='vim'
export BROWSER='firefox'
export WORKON_HOME='~/.virtualenvs'
export WOW="$HOME/Games/world-of-warcraft-classic/drive_c/Program Files (x86)/World of Warcraft/_classic_"

# store pass as selection
export PASSWORD_STORE_X_SELECTION=primary

# aliases

alias vpn='sudo openvpn /etc/openvpn/client/stylight.conf'

# manage
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

alias cg='git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
alias wg='git --git-dir=$HOME/.wow/ --work-tree=$WOW'

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
alias grb='git fetch && git rebase origin/master'

source /usr/bin/virtualenvwrapper.sh

ci() {
  project=${PWD##*/}
  surf "https://app.circleci.com/pipelines/github/stylight/$project" > /dev/null 2>&1 &
}

alias threema='surf "https://web.threema.ch/" > /dev/null 2>&1 &'

if [[ ! $DISPLAY ]]; then
  startx
fi

