#!/usr/bin/bash

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

NID_FILE=/tmp/NID_MULTIMEDIA
NID=$(cat $NID_FILE)

function get_volume {
  pamixer --get-volume
}

function is_mute {
  pamixer --get-mute
}

function send_notification {
  if [ $(is_mute) = true ]; then
    echo "mute"
    icon="audio-volume-muted"
    message="Audio Muted"
    volume=0
  else
    volume=$(get_volume)
    message="Set audio to $volume%"
    if (( $volume >= 66 )); then
      icon="audio-volume-high"
    elif (( $volume >= 33 )); then
      icon="audio-volume-medium"
    else
      icon="audio-volume-low"
    fi
  fi
  if [[ $NID  =~ ^[0-9]+$ ]]; then
    $(notify-send -r $NID -i "$icon" -e -u normal -h int:value:$volume "$message")
  else
    NID=$(notify-send -p -i "$icon" -e -u normal -h int:value:$volume "$message")
    echo $NID > $NID_FILE
  fi

}

case $1 in
  up)
    pamixer -u -i 5
    send_notification
    ;;
  down)
    pamixer -u -d 5
    send_notification
    ;;
  mute)
    pamixer -t
    send_notification
    ;;
esac
