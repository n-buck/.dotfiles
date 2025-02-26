#!/usr/bin/env bash

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

NID_FILE=/tmp/NID_MULTIMEDIA
NID=$(cat $NID_FILE)

function get_volume {
  if [[ $1 == mic ]]; then
    pamixer --default-source --get-volume
  else
    pamixer --get-volume
  fi
}

function is_mute {
  if [[ $1 == mic ]]; then
    pamixer --default-source --get-mute
  else
    pamixer --get-mute
  fi
}

function send_notification {
  if [ $(is_mute $1) = true ]; then
    icon="audio-volume-muted"
    message="Audio Muted"
    if [[ $1 == mic ]]; then
      message="Microphone Muted"
    fi
    volume=0
  else
    volume=$(get_volume $1)
    message="Set $1 audio to $volume%"
    if (( $volume >= 66 )); then
      icon="audio-volume-high"
    elif (( $volume >= 33 )); then
      icon="audio-volume-medium"
    elif (( $volume > 0 )); then
      icon="audio-volume-low"
    else
      icon="audio-volume-muted"
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
  mic-up)
    pamixer --default-source -u -i 5
    send_notification mic
    ;;
  mic-down)
    pamixer --default-source -u -d 5
    send_notification mic
    ;;
  mic-mute)
    pamixer --default-source -t
    send_notification mic
    ;;
esac
