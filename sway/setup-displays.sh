#!/usr/bin/env bash

previous_state=""

while true; do
  output_info=$(swaymsg -t get_outputs)

  if echo "$output_info" | grep "HDMI-A-1"; then
    current_state="hdmi"
  else
    current_state="internal"
  fi

  if [[ "$current_state" != "$previous_state" ]]; then
    if [[ "$current_state" == "hdmi" ]]; then
      swaymsg output HDMI-A-1 mode 1920x1080 pos 0 0 enable
      swaymsg output eDP-1 disable
    else
      swaymsg output eDP-1 mode 1440x900 pos 0 0 enable
      swaymsg output HDMI-A-1 disable
    fi
    previous_state="$current_state"
  fi

  sleep 2
done

