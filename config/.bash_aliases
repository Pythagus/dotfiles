# Folder commands.
alias ll='ls -lF --color=auto'
alias la='ls -alF --color=auto'
alias grep='grep --color=auto'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias suspend='systemctl suspend ; i3lock -i ~/Pictures/chèvre.png'

# Wifi commands.
function wifi_current() {
  nmcli -t -f NAME connection show --active
}

function wifi_connect() {
  COMMAND="nmcli device wifi connect $1"
  
  if [[ $# == 2 ]] ; then
    COMMAND="${COMMAND} password $2"
  fi

  eval $COMMAND
}

function wifi_disconnect() {
  eval "nmcli c down id $(wifi_current)"
}

alias wifi-list="nmcli device wifi list"
alias wifi-connect=wifi_connect
alias wifi-current=wifi_current
alias wifi-disconnect=wifi_disconnect

# System
function copyToClipboard() {
  return "echo $1 | xclip -sel clipboard"
}
alias light="sudo chmod 777 /sys/class/backlight/intel_backlight/brightness"
alias cpy=copyToClipboard

# TOR browser
alias tor="cd ~/tor && ./start-tor-browser.desktop && cd ~"

# INSA connections.
alias vpn="sudo openfortivpn -u dmolina vpn.insa-toulouse.fr:443"

# Git
# To encrypt a file : gpg --output .gitkey.gpg --symmetric key_file
alias git-key='gpg --decrypt .gitkey.gpg 2> /dev/null | xsel -b'

