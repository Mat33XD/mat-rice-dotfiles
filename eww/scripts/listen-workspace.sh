#!/usr/bin/env bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u UNIX-CONNECT:"$SOCKET" - | while read -r line; do

    if echo "$line" | grep -q "workspace"; then
        echo true
        sleep 1
        echo false
    fi

done