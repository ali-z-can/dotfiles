#!/bin/bash

/home/alican/.screenlayout/3disp.sh
setxkbmap -layout en -option "caps:swapescape"
setxkbmap -option "caps:escape"
feh --bg-scale /home/alican/Downloads/background2.png
sudo mount -a
/home/alican/.dwm/scripts/bar.sh &

