#!/bin/bash

export TZ=Asia/Kolkata
# Debug flag (set to 1 to enable logging)
DEBUG=1
LOGFILE="/var/log/schedule_power.log"

log() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOGFILE"
    fi
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <wakeup_time>"
    echo "Example: $0 '08:00'"
    exit 1
fi

WAKEUP_TIME=$1
log "Triggered with wakeup=$WAKEUP_TIME"

# Disable flag check
if [ -f /tmp/disable_wakeup ]; then
    log "Disabled via /tmp/disable_wakeup."
    exit 0
fi

# RTC wake scheduling
WAKE_TS=$(date -d "tomorrow $WAKEUP_TIME" +%s)
log "Scheduling RTC wake-up at: $(date -d @$WAKE_TS)"
# Step 1: Set RTC wake time (no immediate suspend)
if rtcwake --local -m no -t "$WAKE_TS"; then
    log "RTC wakeup set for $(date -d @$WAKE_TS)"
else
    log "Failed to set RTC wake!"
    exit 1
fi

# Step 2: Wait to ensure alarm is armed
sleep 60
log "Slept for 1 min after setting RTC."

# Step 3: Shut down the system
log "Shutting down the system now."
sudo shutdown -h now
