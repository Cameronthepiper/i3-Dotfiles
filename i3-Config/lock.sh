#!/usr/bin/env sh

img="/tmp/lock.png"

# Take screenshot
scrot "$img"

# Pixelate (ImageMagick 7 compatible)
magick "$img" -scale 10% -scale 1000% "$img"

# Gruvbox colors
bg="#282828"
fg="#ebdbb2"
red="#cc241d"
blue="#458588"
yellow="#d79921"
green="#98971a"

# Automatic screen resolution detection
res=$(xdpyinfo | awk '/dimensions/{print $2}')
width=$(echo $res | cut -d'x' -f1)
height=$(echo $res | cut -d'x' -f2)

# Positioning (bottom right)
# Padding from corner: 40px from right, 40px from bottom
time_x=$((width - 40))
time_y=$((height - 100))
date_x=$((width - 40))
date_y=$((height - 60))

# Lockscreen
i3lock \
  --image="$img" \
  --inside-color=$bg \
  --ring-color=$yellow \
  --line-color=00000000 \
  --keyhl-color=$blue \
  --bshl-color=$red \
  --separator-color=00000000 \
  --insidever-color=$green \
  --ringver-color=$green \
  --insidewrong-color=$red \
  --ringwrong-color=$red \
  --indicator \
  --radius=120 \
  --ring-width=10 \
  --verif-text="Verifying..." \
  --wrong-text="Nope!" \
  --verif-color=$fg \
  --wrong-color=$fg \
  --time-color=$fg \
  --date-color=$fg \
  --time-font="JetBrainsMono NFM" \
  --date-font="JetBrainsMono NFM" \
  --time-size=48 \
  --date-size=20 \
  --time-pos="${time_x}:${time_y}" \
  --date-pos="${date_x}:${date_y}" \
  --time-align=2 \
  --date-align=2

rm "$img"
