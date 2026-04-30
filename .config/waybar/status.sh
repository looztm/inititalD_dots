#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)


if [ "$STATUS" == "" ]; then
    echo '{"text": "", "tooltip": false, "class": "hidden"}'
elif [ "$STATUS" == "Playing" ]; then
    echo '{"text": "", "class": "playing", "tooltip": false}'
else
    echo '{"text": "", "class": "stopped", "tooltip": false}'
fi