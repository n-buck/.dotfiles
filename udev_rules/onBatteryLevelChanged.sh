#!/bin/bash
device=/org/freedesktop/UPower/devices/battery_BAT0

state=$(upower -i $device | grep state | sed 's/.* //')
percentage=$(upower -i $device | grep percentage | sed 's/.* //')
percentage=${percentage::-1}

notify() {
  echo $1 >> /tmp/battery-test.log
#  /usr/bin/notify-send $1
}

if [[ $state == discharging ]]; then
  if (( $percentage <= 20 )); then
    notify "Less than 20% accu remaining! Switching to power-saver mode."
    brightness=$(xbacklight -get)
    if (( $brightness < 20)); then
      xbacklight -set 0;
    else
      xbacklight -set 10;
    fi
    powerprofilesctl set power-saver
  else
    notify "Discharging"
  fi
else
  xbacklight -inc 10;
  powerprofile=$(powerprofilesctl get)
  if [[ $powerprofile == power-saver ]]; then
    notify "Charging! Switch to balanced mode."
    powerprofile set balanced
  else
    notify "Charging"
  fi
fi

