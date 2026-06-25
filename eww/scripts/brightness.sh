#!/bin/bash
print_brightness() {
  brightness=$(brightnessctl -m | tr -cs '0-9' ' ' | awk '{print $2}')
  echo $brightness
}

print_brightness

udevadm monitor --subsystem-match=backlight | while read -r _; do
  print_brightness
done
