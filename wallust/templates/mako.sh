font=DepartureMono Nerd Font 11

background-color={{background}}cc
text-color={{foreground}}ff

width=360
height=120
margin=8
outer-margin=8
padding=10

border-size=2
border-color={{color4}}ff
border-radius=4

progress-color=source {{color2}}ff

icons=1
max-icon-size=32
icon-path=/usr/share/icons/Tela-circle-dracula:/usr/share/icons/hicolor

markup=1
actions=1
history=1
max-history=20
format=<b>%s</b>\n%b
text-alignment=left

default-timeout=5000
ignore-timeout=0
group-by=category
max-visible=5

layer=overlay
anchor=top-right

on-button-left=invoke-default-action
on-button-middle=dismiss
on-button-right=dismiss
on-touch=dismiss
on-notify=none

[urgency=high]
background-color={{color1}}ff
border-color={{color9}}ff
text-color={{foreground}}ff
default-timeout=0

[urgency=low]
border-color={{color8}}ff
default-timeout=3000

[category=volume]
default-timeout=1500

[category=brightness]
default-timeout=1500