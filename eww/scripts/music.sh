#!/bin/bash

WIDTH=25
DELAY=0.3
GAP=" - <> - "

LAST_SONG=""

while true; do
  SONG="$(mpc current --format '%artist% - %title%')"
  [ -z "$SONG" ] && SONG="None"

  if [[ "$SONG" == "$LAST_SONG" ]]; then
    sleep 0.5
    continue
  fi

  LAST_SONG="$SONG"

  BASE="$SONG$GAP"
  TEXT="$BASE$BASE"
  LEN=${#BASE}

  for ((i=0; ; i++)); do
    CURRENT="$(mpc current --format '%artist% - %title%')"
    [[ "$CURRENT" != "$SONG" ]] && break

    OFFSET=$(( i % LEN ))
    printf "%s\n" "${TEXT:OFFSET:WIDTH}"
    sleep "$DELAY"
  done
done
