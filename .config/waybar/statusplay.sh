STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" != "" ]; then
    echo '{"text": "󰑟", "tooltip": false, "class": "active"}'
    
else 
    echo '{"text": "", "class": "hidden", "tooltip": false}'
fi