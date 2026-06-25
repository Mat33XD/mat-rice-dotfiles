#!/usr/bin/env bash

FONDOS_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
STATE_FILE="$HOME/.cache/awww_index"
DEFAULT_WALLPAPER="${DEFAULT_WALLPAPER:-$FONDOS_DIR/patos.webp}"

if [[ -f "$STATE_FILE" ]]; then
    mapfile -d '' files < <(find "$FONDOS_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 | sort -z)

    saved=$(<"$STATE_FILE")
    total=${#files[@]}

    if [[ "$saved" =~ ^[0-9]+$ ]] && (( saved < total )); then
        awww img "${files[$saved]}" \
            --resize crop \
            --transition-type wipe \
            --transition-angle 30 \
            --transition-fps 30
        exit 0
    fi
fi

awww img "$DEFAULT_WALLPAPER" \
    --resize crop \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-fps 30
