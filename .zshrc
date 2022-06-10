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
export PATH=$HOME/.local/bin:$HOME/.local/bin/statusbar:$PATH
export EDITOR='vim'
export SUDO_EDITOR='vim'
export BROWSER='firefox'
export WORKON_HOME='~/.virtualenvs'
export LC_ALL=en_US.UTF-8
export LAND=en_US.UTF-8
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export PSQL_PAGER='less'
export PDFTRON_LICENSE_KEY_FRONTEND='dummy'
#export PDFTRON_LICENSE_KEY_BACKEND='demo:1630439198606:78fddca30300000000db4215d30d65e471dbfde5148d94236b11ba888b'

# store pass as selection
export PASSWORD_STORE_X_SELECTION=primary

## aliases

alias vpn='sudo openvpn /etc/openvpn/client/dev-vpn.ovpn'

## manage
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

alias cg='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

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
alias awsaudit='aws --profile audit'
alias awsbackup='aws --profile backup'
alias awsbi='aws --profile bi'
alias awsprod='aws --profile legacy'
alias awsdev='aws --profile development'
alias awsinfra='aws --profile infra'
alias awsstaging='aws --profile staging'
alias awsproduction='aws --profile production'

awslogin() {
  awsaudit sso login
  awsbackup sso login
  awsbi sso login
  awsdev sso login
  awsinfra sso login
  awsprod sso login
  awsstaging sso login
  awsproduction sso login
}

my-ip() {
  dig +short txt ch whoami.cloudflare @1.0.0.1 | tr -d '"' | sed -e 's/$/\/32/'
}

tunnel() {
  env="$1"
  cidr="$(my-ip)"
  query="Reservations[].Instances[].{id: InstanceId, sg: SecurityGroups[].GroupId, name: Tags[?Key==\`Name\`].Value}[].{id: id, sg: sg, name: name[0]} | [?name==\`tonic-proxy\`].sg"
  security_group="$(aws --profile $env ec2 describe-instances --output text --query $query)"

  query="SecurityGroups[].IpPermissions[].IpRanges[].CidrIp"
  ingress=$(aws --profile $env ec2 describe-security-groups --group-ids $securit_group --output text --query $query)

  if [[ $ingress =~ $cidr ]];
  then
    echo "$security_group already allows access to $cidr"
  else
    echo "Adding $cidr to $security_group ingress rules..."
    permissions="FromPort=22,IpProtocol=\"TCP\",IpRanges=[{CidrIp=\"$cidr\",Description=\"raul ssh access\"}],ToPort=22"
    $(aws --profile $env ec2 authorize-security-group-ingress --group-id $security_group --ip-permissions $permissions)
    $echo "done"
  fi
}

get-instance() {
  aws --profile legacy ec2 describe-instances | jq '[.Reservations[].Instances[] | {id: .InstanceId, state: .State, name: .Tags | map(select(.Key == "Name"))[].Value}] | map(select(.name == "master-Worker")) | map(select(.state.Name == "running"))[] | .id'
}

devinstance() {
  #query="[.Environments[].EnvironmentName] | map(select(startswith(\"PCF-$1\"))) | .[0]"
  #envname=$(aws --profile development elasticbeanstalk describe-environments | jq -r ${query})
  query="Environments[].EnvironmentName | [?starts_with(@, \`$1\`)] | [?ends_with(@, \`Worker\`)] | [0]"
  envname=$(aws --profile development elasticbeanstalk describe-environments --output text --query $query)

  aws --profile development elasticbeanstalk describe-instances-health \
    --environment-name ${envname} \
    --attribute-names All \
    --output text \
    --query 'InstanceHealthList[0].InstanceId'
}

prodinstance() {
  aws --profile legacy elasticbeanstalk describe-instances-health \
    --environment-name "$1" \
    --attribute-names All \
    --output text \
    --query 'InstanceHealthList[0].InstanceId'
}

copyinstance() {
  aws --profile legacy ec2 describe-instances \
    --filters "Name=tag-value,Values=db-copy" \
    --output text \
    --query 'Reservations[].Instances[0].InstanceId'
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
    copy)
      instance=$(copyinstance)
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

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

ci() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  branch=$(rawurlencode $branch)
  if [[ -n $branch ]]; then
    #project=${PWD##*/}
    project=$(basename $(git remote get-url origin) | sed -e 's/\.git$//')
    echo "https://app.circleci.com/pipelines/github/alasco-tech/$project?branch=$branch"
    surf "https://app.circleci.com/pipelines/github/alasco-tech/$project?branch=$branch" > /dev/null 2>&1 &
  else
    surf "https://app.circleci.com/pipelines/github/alasco-tech/alasco-app" > /dev/null 2>&1 &
  fi
}

if [[ ! $DISPLAY ]]; then
  startx
fi

