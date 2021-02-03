#!/bin/bash

STATUS=$( playerctl status )
ARTIST=$( playerctl metadata artist )
TITLE=$( playerctl metadata title )

if [[ $STATUS == "Playing" ]]
then
    echo -e "| <fc=#00ffff><fn=1>\uf001</fn> $ARTIST - $TITLE</fc>"
else
    echo -e ""
fi
exit 0