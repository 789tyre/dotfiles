#! /usr/bin/bash

if [ $(setxkbmap -query | awk '/layout:/ {print $2}') = 'gb' ]; then
  echo hi
  setxkbmap -layout dvorak
else
  setxkbmap -layout gb
  echo sntheoau
fi
