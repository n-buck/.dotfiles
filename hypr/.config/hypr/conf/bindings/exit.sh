if pgrep -x Hyprland >/dev/null; then
  hyprctl dispatch exit 0 sleep 2
  sleep 12
fi

if pgrep -x Hyprland >/dev/null; then
  killall -9 Hyprland
fi


