STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" == "Stopped" ]; then
    echo '{"text": "", "tooltip": false, "class": "hidden"}'
fi


POSITION=$(playerctl metadata --format "{{ duration(mpris:length - position) }}" 2>/dev/null)

if [ -n "$POSITION" ]; then
    echo "{\"text\": \"$POSITION\", \"tooltip\": false}"
else
    echo '{"text": "", "tooltip": false, "class": "hidden"}'
fi

#!/bin/bash

#STATUS=$(playerctl status 2>/dev/null)

# Если статус не Playing — выводим пустоту и выходим
#if [ "$STATUS" == "Stopped" ]; then
#    echo '{"text": "", "tooltip": false, "class": "hidden"}'
#fi

# Если играет — показываем позицию
#POSITION=$(playerctl position 2>/dev/null)

#if [ -n "$POSITION" ]; then
#    # Форматируем в MM:SS
#    POSITION=$(printf "%.0f" "$POSITION")
#    MIN=$((POSITION / 60))
#    SEC=$((POSITION % 60))
#    FORMATTED=$(printf "%02d:%02d" $MIN $SEC)
#    echo "{\"text\": \"$FORMATTED\", \"tooltip\": false, \"class\": \"playing\"}"
#else
#    echo '{"text": "", "tooltip": false, "class": "hidden"}'
#fi