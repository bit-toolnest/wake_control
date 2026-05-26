#!/bin/bash

WAKEUP=$1
SHUTDOWN=$2

if [ -z "$WAKEUP" ] || [ -z "$SHUTDOWN" ]; then
    echo "Usage: $0 -Pwakeup=HH:MM -Pshutdown=HH:MM"
    exit 1
fi

SCRIPT_PATH="/usr/local/sbin/schedule_power.sh"

# Move script into system bin
cp -f schedule_power.sh "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

# Calculate cron time from shutdown argument
HOUR=$(echo "$SHUTDOWN" | cut -d: -f1)
MIN=$(echo "$SHUTDOWN" | cut -d: -f2)

# Install cron job to run schedule_power.sh at shutdown time
CRON_LINE="$MIN $HOUR * * * $SCRIPT_PATH $WAKEUP"
( crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" ; echo "$CRON_LINE" ) | crontab -

echo "Installed cron job: $CRON_LINE"
