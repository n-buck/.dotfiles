#!/usr/bin/env bash

icon="$HOME/.i3/lock.png"
tmpbg='/tmp/screen.png'
tmpbgL='/tmp/screenL.png'
tmpbgR='/tmp/screenR.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
#convert "$tmpbg" "$icon"  -gravity center -geometry +960+0 -composite -matte "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
i3lock -u -i "$tmpbg"
rm "$tmpbg"
