ZSH='/home/raul/.zsh'

for config_file ($ZSH/conf/*.zsh); do
  source $config_file
done

#echo 'configs loaded'
#echo "$(foo)"
