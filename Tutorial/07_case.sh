#!/usr/bin/bash

day=$(date +%w)  # +%w is the command to display the day of the week

case $day in
    0)
        echo Sunday
        ;;
    1)
        echo Monday
        ;;
    2)
        echo Tuesday
        ;;
    3)
        echo Wednesday
        ;;
    4)
        echo Thursday
        ;;
    5)
        echo Friday
        ;;
    6)
        echo Saturday
        ;;
esac

case $day in
    4|5)
        echo "Yay! No Buet!!"
        ;;
    *)
        echo "No fun now :'("
        ;;
esac

filename="backup_2026.tar.gz"

case "$filename" in
    *.jpg|*.png|*.gif)
        echo "Image"
        ;;
    *.tar.gz|*.tgz|*.zip)
        echo "Zipped file"
        ;;
    *)
        command ...
        ;;
esac