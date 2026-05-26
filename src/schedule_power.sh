#!/bin/bash

export TZ=Asia/Kolkata
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

if [ -f /tmp/disable_wakeup ]; then
    log "Disabled via /tmp/disable_wakeup."
    exit 0
fi

# --- LOGIC: same-day or tomorrow ---
NOW=$(date +%s)
TODAY_WAKE_TS=$(date -d "$WAKEUP_TIME" +%s 2>/dev/null)

if [ "$TODAY_WAKE_TS" -gt "$NOW" ]; then
    WAKE_TS=$TODAY_WAKE_TS
    log "Scheduling RTC wake-up today at: $(date -d @$WAKE_TS)"
else
    WAKE_TS=$(date -d "tomorrow $WAKEUP_TIME" +%s)
    log "Scheduling RTC wake-up tomorrow at: $(date -d @$WAKE_TS)"
fi

# Step 1: Set RTC wake time
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
