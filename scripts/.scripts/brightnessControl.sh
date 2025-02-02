#!/usr/bin/env bash

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

NID_FILE=/tmp/NID_MULTIMEDIA
NID=$(cat $NID_FILE)

function get_brightness {
  xbacklight -get | cut -d '.' -f 1
}


function send_notification {
  brightness=$(get_brightness)
  if (( brightness > 50 )); then
    icon="weather-clear"
  else
    icon="weather-clear-night"
  fi;
  message="$1 $brightness%"

  if [[ $NID =~ ^[0-9]+$ ]]; then
    $(notify-send -r $NID -i "$icon" -e -u normal -h int:value:$brightness "$message")
  else
    NID=$(notify-send -p -i "$icon" -e -u normal int:value:$brightness "$message")
    echo $NID > $NID_FILE
  fi
}

case $1 in
  up)
    # increase the backlight by 5%
    xbacklight -inc 5
    send_notification "Increase Brighness to"
    ;;
  down)
    # decrease the backlight by 5%
    xbacklight -dec 5
    send_notification "Increase Brighness to"
    ;;
esac
