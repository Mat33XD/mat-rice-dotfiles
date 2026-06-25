#!/bin/bash

print_volume() {
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  if [ "$mute" = "yes" ]; then
    echo [${vol},'true']
  else
    echo [${vol},'false']
  fi
}

print_volume

pactl subscribe | grep --line-buffered "sink" | while read -r _; do
  print_volume
done
