#!/bin/bash
hotkey=$(awk -F, '{print $1 "  <span color=\"#1e4584\">(" $2 ")</span>" }' /opt/extend/extend_wm_search | rofi -dmenu -markup-rows -p "select command:" -a 0 -format 'd')
echo "hotkey: $hotkey"
line=$(awk -F',' "NR==$hotkey { print \$1}" /opt/extend/extend_wm_search)
#extend-shell key exec $line
