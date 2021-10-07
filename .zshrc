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
#bindkey '^S' history-incremental-search-forward

# env
export PATH=$HOME/.local/bin:$PATH
export EDITOR='vim'
export SUDO_EDITOR='vim'
export BROWSER='firefox'
export WORKON_HOME='~/.virtualenvs'
export WOW="$HOME/Games/world-of-warcraft-classic/drive_c/Program Files (x86)/World of Warcraft/_classic_"

# store pass as selection
export PASSWORD_STORE_X_SELECTION=primary

# aliases

alias vpn='sudo openvpn /etc/openvpn/client/dev-vpn.ovpn'

## manage
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

alias cg='git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
alias wg='git --git-dir=$HOME/.wow/ --work-tree=$WOW'

## git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcm='git checkout master'
alias gd='git diff'
alias gfo='git fetch origin'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias gl='git log --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glg='glola'
alias gra='git remote add'
alias grv='git remote -v'
alias gst='git status'
#alias grb='git fetch && git rebase origin/master'

gco() {
  if [[ -n $1 ]]; then
    branch="$1"
  else
    branch=staging
  fi
  git fetch && git checkout ${branch}
}

grb() {
  if [[ -n $1 ]]; then
    branch="$1"
  else
    branch=$(git rev-parse --abbrev-ref HEAD)
  fi
  echo "Rebasing on origin/${branch}"
  git fetch && git rebase origin/${branch}
}

## aws
alias awsprod='aws --profile legacy'
alias awsdev='aws --profile development'
alias awsinfra='aws --profile infra'
alias awsbackup='aws --profile backup'

awslogin() {
  awsprod sso login
  awsdev sso login
  awsinfra sso login
  awsbackup sso login
}

get-instance() {
  aws --profile legacy ec2 describe-instances | jq '[.Reservations[].Instances[] | {id: .InstanceId, state: .State, name: .Tags | map(select(.Key == "Name"))[].Value}] | map(select(.name == "master-Worker")) | map(select(.state.Name == "running"))[] | .id'
}

devinstance() {
  query="[.Environments[].EnvironmentName] | map(select(startswith(\"PCF-$1\"))) | .[0]"
  envname=$(aws --profile development elasticbeanstalk describe-environments | jq -r ${query})

  awsdev elasticbeanstalk describe-instances-health \
    --environment-name ${envname} \
    --attribute-names All \
  | jq -r '.InstanceHealthList[0].InstanceId'
}

prodinstance() {
  awsprod elasticbeanstalk describe-instances-health \
    --environment-name "$1" \
    --attribute-names All \
  | jq -r '.InstanceHealthList[0].InstanceId'
}

ebconnect() {
  prod="(prod|production|master)"
  case "$1" in
    $~prod)
      instance=$(prodinstance master-Worker)
      profile='legacy'
      ;;
    staging)
      instance=$(prodinstance staging-Worker)
      profile='legacy'
      ;;
    *)
      instance=$(devinstance "$1")
      profile='development'
      ;;
  esac
  echo "Connecting to instance in environment: $1, instance: ${instance}"
  aws --profile $profile ssm start-session --target ${instance}
}

copyprod() {
  awsdev="aws --profile development"
  awslegacy="aws --profile legacy"
  query="[.Stacks[].StackName] | map(select(startswith(\"alasco-pcf-$1\")))[0]"
  stackname=$(aws --profile development cloudformation describe-stacks | jq -r ${query})

  query=".StackResources | map(select(.ResourceType == \"AWS::RDS::DBInstance\")) | .[].PhysicalResourceId"
  rdsinstance=$(aws --profile development cloudformation describe-stack-resources --stack-name $stackname | jq -r ${query})
  endpoint="$rdsinstance.cl0a1fkzaiko.eu-central-1.rds.amazonaws.com"

  echo "Copying production data to stack: ${stackname}, db endpoint: ${endpoint}"

  cmd="${awslegacy} ssm start-automation-execution"
  name="--document-name \"Alasco-Automation-UpdateBranchDB\""
  version='--document-version "\$DEFAULT"'
  params="--parameters '{\"endpoint\":[\"${endpoint}\"],\"additionalParameters\":[\"--exclude-audit-log\"]}'"
  region="--region eu-central-1"
  echo "${cmd} ${name} ${version} ${params} ${region}"

  #automation=$(aws ssm start-automation-execution \
  #  --document-name "Alasco-Automation-UpdateBranchDB" \
  #  --document-version "\$DEFAULT" \
  #  --parameters ${params} \
  #  --region eu-central-1 \
  #| jq -r '.AutomationExecutionId')

  #job="https://eu-central-1.console.aws.amazon.com/systems-manager/automation/execution/$automation?region=eu-central-1"
  #echo $job
  #surf $job > /dev/null 2>&1 &
}


source /usr/bin/virtualenvwrapper.sh

ci() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ -n $branch ]]; then
    project=${PWD##*/}
    surf "https://app.circleci.com/pipelines/github/alasco-tech/$project?branch=$branch" > /dev/null 2>&1 &
  else
    surf "https://app.circleci.com/pipelines/github/alasco-tech/alasco-app" > /dev/null 2>&1 &
  fi
}

alias threema='surf "https://web.threema.ch/" > /dev/null 2>&1 &'

if [[ ! $DISPLAY ]]; then
  startx
fi

