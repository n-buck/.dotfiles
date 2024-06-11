#!/usr/bin/env bash
# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

NID_FILE=/tmp/NID_brightness
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
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
  message="$1 $brightness%"
  echo $message
  # Send the notification
  if [ -n $NID ]; then
    $(notify-send -r $NID -i "$icon" -e -u normal -h int:value:$brightness "$message")
  else
    NID=$(notify-send -p -i "$icon" -e -u normal int:value:$brightness "$message")
    echo $NID > $NID_FILE
  fi
}

case $1 in
  up)
    xbacklight -inc 5
    send_notification "Increase Brighness to"
    ;;
  down)
    xbacklight -dec 5
    send_notification "Decrease Brighness to"
    ;;
esac
