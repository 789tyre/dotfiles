#! /usr/bin/bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush() }' "$@"
}

get_cmus() {
  output=$(cmus-remote -Q)
  # message=""
  path=$(echo "$output" | awk '/^file/ {print}' | cut -c 12-)
  song=$(echo "$output" | awk '/^tag title/ {print}' | cut -c 11-)
  artist=$(echo "$output" | awk '/^tag artist/ {print}' | cut -c 12-)
  cmusstatus=$(echo "$output" | awk '/^status/ {print $NF}')
  duration=$(echo "$output" | awk '/^duration/ {print $NF}')
  position=$(echo "$output" | awk '/^position/ {print $NF}')

  echo -n "^ca(1, cmus-remote -u)"
  case $cmusstatus in
    "playing")
      # echo -n " ►"
      echo -n "^i($bitmaps/play.xbm)"
      ;;
    "paused")
      # echo -n "▐▐"
      echo -n "^i($bitmaps/pause.xbm)"
      ;;
    "stopped")
      echo -n ""
      # This might cause a problem
      return 0
      ;;
    *)
      return 0
      ;;
  esac

  echo -n " ($(expr $duration - $position | xargs -I u date -d@u +-%M:%S)"
  echo -n "/"
  echo -n "$(date -d@$duration +%M:%S)) "

  if [[ $artist = *[!\ ]* ]]; then
    echo -n "$artist - $song"
  elif [[ $path = *[!\ ]* ]]; then
    echo $path | awk -F "/" '{print $NF}' | xargs echo -n
  fi

  echo -n "^ca()"
}

get_mem() {
  total=$(awk '/^MemTotal: / {print $2}' /proc/meminfo)
  free=$(awk '/^MemAvailable: / {print $2}' /proc/meminfo)
  used=$((total - free))
  echo -n "Mem: $((used*100/total))%"
}

get_batt() {
  percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage:/ {print $2}')
  echo -n "Bat: $percentage"
}

get_key() {
  key=$(setxkbmap -query | awk '/layout:/ {print substr($2, 1, 2)}')
  echo -n "Key: $key"
}

# Variables
monitor=${1:-0}
geometry=( $(hc monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
  echo "Invalid monitor $monitor"
  exit 1
fi
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=20
font="-*-dejavu sans-medium-r-normal-*-16-120-100-100-p-0-*-*"
# font="-bitstream-terminal-bold-r-normal--15-140-100-100-c-110-iso8859-1"
bitmaps="$HOME/.config/dzen/bitmaps"

hc pad $monitor $panel_height


{
  while true; do
    date +"date  ^fg(#eaeaea)%a %Y-%m-%d %H:%M:%S"
    sleep 1 || break;
  done > >(uniq_linebuffered) &

  childpid=$!
  hc --idle
  kill $childpid
} | {
  IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
  date=""

  while true ; do
    ## print everything

    # indexes
    for i in "${tags[@]}"; do
      echo -n "^p(5)"
      case ${i:0:1} in
        '#')
          echo -n "^bg(#00bc0c)^fg(#141414)"
          ;;
        '-' | '+')
          echo -n "^bg(#005f7f)^fg(#141414)"
          ;;
        '%')
          echo -n "^bg(#007ca5)^fg(#141414)"
          ;;
        ':')
          echo -n "^bg()^fg(#9e149c)"
          ;;
        '!')
          echo -n "^bg(#ff0675)^fg(#141414)"
          ;;
        *)
          echo -n "^bg()^fg()"
          ;;
      esac
      echo -n "^ca(1, herbstclient use_index $(expr ${i:1:2} - 1)) ${i:1:2} ^ca()"
    done
    echo -n "^bg()^fg()"

    # update cmus
    echo -n "^p(5)$(get_cmus)"

    echo -n "^p(_CENTER)"
    center="$date"
    center_text_only=$(echo -n "$center" | sed 's.\^[^(]*([^)]*)..g')
    width_center=$(textwidth "$font" "$center_text_only")
    # echo -n "^p(-$((width_center + 96)))$center"
    echo -n "^p(-$((width_center / 2)))$center"

    # update right side
    # echo -n "^p(_RIGHT)"
    right="$(get_key) $(get_batt) $(get_mem)"
    right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
    width_right=$(textwidth "$font" "$right_text_only")
    # echo -n "^p(-$((width_right + 16)))$right"
    echo -n "^pa($((panel_width - width_right)))$right"

    echo

    # Update everything
    read -ra cmd || break

    case "${cmd[0]}" in
      date)
        date="${cmd[@]:1}"
        ;;
      tag*)
        IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
        ;;
      quit_panel)
        exit
        ;;
      reload)
        exit
        ;;
    esac
  done
} | dzen2 -p -w $panel_width -h $panel_height -x $x -y $y -fg "grey" -m -ta l -fn "$font"
