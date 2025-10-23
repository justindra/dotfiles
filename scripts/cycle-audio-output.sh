#!/bin/bash

SINK_IDS=$(wpctl status | sed -n '/Sinks:/,/Sink endpoints:/p' | grep '[0-9]\+\.' | sed 's/^[^0-9]*\([0-9]\+\)\..*/\1/')

CURRENT_SINK=$(wpctl status | sed -n '/Sinks:/,/Sink endpoints:/p' | grep '\*' | sed 's/^[^0-9]*\([0-9]\+\)\..*/\1/')

SINK_ARRAY=($SINK_IDS)

for i in "${!SINK_ARRAY[@]}"; do
    if [[ "${SINK_ARRAY[$i]}" == "$CURRENT_SINK" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#SINK_ARRAY[@]} ))
        NEXT_SINK="${SINK_ARRAY[$NEXT_INDEX]}"
        wpctl set-default "$NEXT_SINK"
        exit 0
    fi
done
