#!/bin/bash

# Get the volume from Pulse Audio
SINK=$( pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
VOLUME=$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )
MUTED=$( pactl list sinks | grep '^[[:space:]]Mute:' | tail -n 1 | grep -oE '[^ ]+$' )

if [[ $MUTED == "no" ]]
then
    echo -e "<fn=1>\uf6a8</fn> $VOLUME%"
else
    echo -e "<fc=#676E7D><fn=1>\uf6a9</fn> $VOLUME%</fc>"
fi
exit 0