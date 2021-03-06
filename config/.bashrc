# Manage .bash_history file content.
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Global bash variables.
color_prompt=yes

# Prompting a nice message.
echo -e "\e[48;5;229m\e[30m    Salut vieux !    \e[0m"

# Make color variables.
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset


nameColor="${bldgrn}"
if [ "${UID}" -eq "0" ]; then
  # Red name for root
  nameColor="${bldred}"
fi

# Function used to prepare the
# user prompt. This is also used
# to refresh it when a command is
# executed.
__prompt_command() {
  local exitCode="$?"
  local pathColor="${txtwht}"
  
  PS1="\n${nameColor}┌─ \u@\h${txtrst} ${pathColor}\w${txtrst}"

  if [ $exitCode != 0 ]; then
    PS1+="${bldylw} [ERR: ${exitCode}]${txtrst} "
  fi

  PS1+="\n${nameColor}└─▶${txtrst} $ "
}

# Set the function to be called after
# a command is executed.
PROMPT_COMMAND=__prompt_command

# Load aliases if any exists.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
  fi
fi

if [ -d ~/dotfiles ] ; then
  export PATH="$HOME/dotfiles/bin:$PATH"
fi

