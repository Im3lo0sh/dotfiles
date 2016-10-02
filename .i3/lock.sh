#!/bin/bash
SOUND=$(amixer sget Master | awk -F"[][]" '/Front Left.*%/ { print $4 }')
amixer -q set Master mute
i3lock-fancy
