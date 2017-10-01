#!/bin/bash
setxkbmap -option caps:super
setxkbmap -option grp:alt_caps_toggle
xmodmap -e "remove shift = Shift_R"
xmodmap -e "add mod4 = Shift_R"

