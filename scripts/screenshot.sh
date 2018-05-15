#!/bin/bash
shutter -s -C -e -o '~/Pictures/$nb_name-%Y-%m-%d.png'
FILENAME="$(ls -dtr1 ~/Pictures/* | tail -1)"
xclip -selection clipboard -t image/png -i ${FILENAME}
