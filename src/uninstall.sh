#!/bin/bash

SCRIPT_PATH="/usr/local/sbin/schedule_power.sh"

# Remove cron job containing schedule_power.sh
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" | crontab -

# Delete the installed script
if [ -f "$SCRIPT_PATH" ]; then
    rm -f "$SCRIPT_PATH"
    echo "Removed $SCRIPT_PATH"
else
    echo "No installed script found at $SCRIPT_PATH"
fi

echo "Uninstall complete: cron entry removed and script deleted."
