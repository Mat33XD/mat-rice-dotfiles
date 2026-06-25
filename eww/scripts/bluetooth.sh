#!/usr/bin/env bash
set -uo pipefail

bt_power() {
    bluetoothctl show | grep -q "Powered: yes" && echo "yes" || echo "no"
}

bt_device() {
    bluetoothctl devices Connected | head -n1 | cut -d ' ' -f3-
}

emit_state() {
    local power device
    power="$(bt_power)"
    device="$(bt_device)"
    printf '["%s","%s"]\n' "$power" "$device"
}

case "${1:-}" in
  scan)
    if pgrep -f "bluetooth.sh scan" | grep -v $$ | grep -q .; then
        exit 0
    fi

    if [ "${BLUETOOTH_DETACHED:-}" != "1" ]; then
        BLUETOOTH_DETACHED=1 setsid bash "$0" scan &
        exit 0
    fi

    bluetoothctl show | grep -q "Powered: yes" || {
        eww update bluetooth-scan='[]'
        exit 0
    }

    eww update bluetooth-scanning=true

    expect -c 'spawn bluetoothctl; send "scan on\r"; sleep 10; send "scan off\r"; expect eof' >/dev/null 2>&1

    OUTPUT="$(
        bluetoothctl devices | awk '
            BEGIN { printf "["; first=1 }
            /^Device/ {
                name = ""
                for(i = 3; i <= NF; i++) name = name $i " "
                sub(/[ \t]+$/, "", name)
                if (name == "" || name ~ /unknown/ || name ~ /^[0-9A-Fa-f:]+$/) next
                if (seen[name]++) next
                gsub(/"/, "\\\"", name)
                if (!first) printf ","
                printf "\"%s\"", name
                first=0
            }
            END { printf "]\n" }
        '
    )"

    eww update bluetooth-scan="$OUTPUT"
    eww update bluetooth-scanning=false
    ;;

  power)
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off >/dev/null 2>&1
    else
        bluetoothctl power on >/dev/null 2>&1
    fi
    ;;

  connect)
    DEVICE="${2:-}"
    [ -n "$DEVICE" ] || exit 0

    MAC="$(bluetoothctl devices | grep -F "$DEVICE" | head -n1 | awk '{print $2}')"
    [ -n "$MAC" ] || exit 0

    bluetoothctl pair    "$MAC" >/dev/null 2>&1 || true
    bluetoothctl trust   "$MAC" >/dev/null 2>&1 || true
    bluetoothctl connect "$MAC" >/dev/null 2>&1 || true
    ;;

  disconnect)
    bluetoothctl devices Connected | while read -r _ MAC _; do
        bluetoothctl disconnect "$MAC" >/dev/null 2>&1
    done
    ;;

  reset)
    bluetoothctl devices | while read -r _ MAC _; do
        bluetoothctl disconnect "$MAC" >/dev/null 2>&1 || true
        bluetoothctl untrust    "$MAC" >/dev/null 2>&1 || true
        bluetoothctl remove     "$MAC" >/dev/null 2>&1 || true
    done
    rm -rf ~/.cache/bluetooth 2>/dev/null || true
    ;;

  *)
    exit 0
    ;;

esac