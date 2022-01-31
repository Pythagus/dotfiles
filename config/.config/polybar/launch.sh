#!/usr/bin/env sh

# Terminate already running bar instances
#killall -q i3bar
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar
pulseaudio -k 2&>/dev/null
pulseaudio --start
polybar default &
