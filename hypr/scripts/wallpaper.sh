#!/usr/bin/env bash

FONDOS_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
STATE_FILE="$HOME/.cache/awww_index"

mapfile -d '' files < <(find "$FONDOS_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 | sort -z)

total=${#files[@]}
(( total == 0 )) && exit 1

index=0
if [[ -f "$STATE_FILE" ]]; then
    saved=$(<"$STATE_FILE")
    [[ "$saved" =~ ^[0-9]+$ ]] && (( saved < total )) && index=$saved
fi

if [[ "$1" == "prev" ]]; then
    next=$(( (index - 1 + total) % total ))
else
    next=$(( (index + 1) % total ))
fi

echo "$next" > "$STATE_FILE"

awww img "${files[$next]}" \
    --transition-type random \
    --transition-duration 0.7 \
    --transition-fps 30

pkill wofi 2>/dev/null

old_hash=$(sha1sum "$HOME/.config/starship.toml" 2>/dev/null)

wallust run "${files[$next]}"

hyprctl reload
makoctl reload
eww reload

timeout=5
while (( timeout-- > 0 )); do
    new_hash=$(sha1sum "$HOME/.config/starship.toml" 2>/dev/null)
    [[ "$old_hash" != "$new_hash" ]] && break
    sleep 1
done

pkill -SIGWINCH kitty
