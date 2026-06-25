#!/usr/bin/env bash

CURRENT=$(hyprctl activeworkspace -j | jq '.id')

WORKSPACES=$(hyprctl workspaces -j)
CLIENTS=$(hyprctl clients -j)

echo "$WORKSPACES" | jq -c \
--argjson clients "$CLIENTS" \
--argjson current "$CURRENT" '

map(
    . as $ws
    | ($clients | map(select(.workspace.id == $ws.id))) as $wins
    | {
        id: $ws.id,
        active: ($ws.id == $current),
        hasWindows: ($wins | length > 0),

        icon:
        (
            if ($wins | length) == 0 then
                "󰧞"
            elif ($wins | length) > 1 then
                ""
            else
                (
                    $wins[0].class
                    |if test("firefox|zen|chromium|brave-browser"; "i") then ""

                    elif test("kitty|wezterm|alacritty"; "i") then ""

                    elif test("codium|code"; "i") then "󰨞"

                    elif test("com.rtosta.zapzap"; "i") then "󰖣"

                    elif test("com.vixalien.sticky"; "i") then ""

                    elif test("steam"; "i") then "󰓓"

                    elif test("obsidian"; "i") then "󱓧"

                    elif test("net.lutris.Lutris|lutris"; "i") then "󰺵"

                    elif test("blueman-manager"; "i") then "󰂯"

                    elif test("prismlauncher|org.prismlauncher.PrismLauncher"; "i") then "󰍳"

                    elif test("krita"; "i") then ""

                    elif test("aseprite|Aseprite"; "i") then "󰹹"

                    elif test("antimicrox|io.github.antimicrox.antimicrox"; "i") then "󰊴"

                    elif test("anki"; "i") then "󰘹"

                    elif test("nemo"; "i") then "󰉖"

                    else ""
                    end
                )
            end
        )
    }
)

| sort_by(.id)

| (map(.id) | index($current)) as $i

| (if ($i - 2) < 0 then 0 else ($i - 2) end) as $start
| .[$start:($start + 5)]

| map(select(. != null))

'