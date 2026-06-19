#!/bin/bash

WALLDIR="$HOME/Pictures/Wallpapers"

get_list() {
  for img in "$WALLDIR"/*; do
    [ -f "$img" ] || continue
    name=$(basename "$img")
    clean_name="${name%.*}"

    echo -en "$clean_name\0icon\x1f$img\n"
  done
}

choice=$(get_list | rofi -dmenu \
  -show-icons \
  -p "󰸉 " \
  -theme-str '
    window {
        width: 820px;
        border-radius: 3px;
        background-color: rgba(0, 0, 0, 0.9);
        border: 1px;
        border-color: rgba(68, 68, 68, 0.67);
        padding: 15px;
    }

    mainbox {
        background-color: transparent;
        children: [ "inputbar", "listview" ];
    }

    inputbar {
        background-color: transparent;
        margin: 0px 0px 10px 0px;
        padding: 2px 5px;
    }

    prompt {
        text-color: #FFFFFFFF;
        background-color: transparent;
    }

    entry {
        background-color: transparent;
        text-color: #FFFFFFFF;
        placeholder: "Search wallpapers...";
        font: "JetBrainsMono Nerd Font 13";
        placeholder-color: #777777FF;
    }

    listview {
        columns: 5;
        lines: 2;
        spacing: 12px;
        scrollbar: false;
        background-color: transparent;
        border: 0px;
    }

    element {
        orientation: vertical;
        padding: 10px;
        border-radius: 3px;
        background-color: transparent;
        text-color: #FFFFFFFF;
        spacing: 8px;
        border: 0px;
    }

    element-icon {
        size: 115px;
        horizontal-align: 0.5;
        background-color: transparent;
    }

    element-text {
        horizontal-align: 0.5;
        font: "JetBrainsMono Nerd Font 11";
        text-color: inherit;
        background-color: transparent;
    }

    element selected.normal {
        background-color: #FFFFFFFF;
        text-color: #000000FF;
    }
  ')

[ -z "$choice" ] && exit

file=""
for f in "$WALLDIR"/*; do
  if [ -f "$f" ] && [ "$(basename "${f%.*}")" = "$choice" ]; then
    file="$f"
    break
  fi
done

[ -z "$file" ] && exit

awww img --transition-fps 60 \
         --transition-type grow \
         --transition-pos center \
         "$file"

LOCKDIR="$HOME/.config/hypr/hyprlock"
LOCKIMG="$LOCKDIR/wallpaper.jpg"

magick "$file" "$LOCKIMG"