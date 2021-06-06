# prompt
#PROMPT='[%{$fg[$NCOLOR]%}B%n%b%{$reset_colors}:%{$fg[red]%}%30<...<%~%<<%{$reset_color%}]%{#fg_bold[blue]%}%(!.#.ツ)%{$reset_color%} '
#PROMPT='[%B%n%b:%F{red}%30<...<%~%<<%f]%B%F{blue}%(!.#.ツ)%f%b '
PROMPT='[%B%n%b:%{$fg[red]%}%30<...<%~%<<%{$reset_color%}]%{$fg_bold[blue]%}%(!.#.ツ)%{$reset_color%} '
RPROMPT='$(right_prompt)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✓ "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗ "

