#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in

  scan)
    {
      printf '['
      nmcli -g SSID dev wifi list \
      | sed '/^$/d' \
      | sort -u \
      | sed 's/.*/"&"/' \
      | paste -sd "," -
      printf ']'
    }
    ;;

  connect)
    SSID="${2:-}"
    PASS="${3:-}"

    if ! nmcli dev wifi connect "$SSID" >/dev/null 2>&1; then
      nmcli dev wifi connect "$SSID" password "$PASS" >/dev/null 2>&1
    fi
    ;;

  disconnect)
    nmcli dev disconnect "$(nmcli -t -f DEVICE,TYPE,STATE dev \
      | awk -F: '$2=="wifi" && $3=="connected"{print $1}')" >/dev/null 2>&1
    ;;

  *)
    exit 0
    ;;
esac
