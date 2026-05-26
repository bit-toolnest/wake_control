# WakeControl – Wake & Shutdown Automation

This project provides a script to automatically enable RTC wake‑up and shutdown the server at scheduled times.

## Installation

Clone the repository and run the installer with your desired wake‑up and shutdown times:

```bash
git clone https://github.com/bitresearch2006/WakeControl.git
cd WakeControl

# Example: wake at 08:00, shutdown at 23:00
./install.sh 08:00 23:00
```
## Time Handling

When you run `install.sh <wakeup_time> <shutdown_time>`, the script decides whether the wake‑up time is scheduled for **today** or **tomorrow**:

- If the wake‑up time is still in the future on the same day, it will schedule for **today**.
- If the wake‑up time has already passed, it will schedule for **tomorrow** at that time.

Example:
- Run at 20:10 with wakeup=20:26 → wake scheduled for today 20:26.
- Run at 21:00 with wakeup=20:26 → wake scheduled for tomorrow 20:26.

This ensures the server always wakes at the next valid occurrence of the time you specify.
The installer will:

Copy the script into /usr/local/sbin/schedule_power.sh

Set executable permissions automatically

Create a cron job that runs daily at the shutdown time, calling the script with the wake‑up time

Log File
The script writes debug logs to:

```Code
/var/log/schedule_power.log
This file records when wake‑up was scheduled, shutdown triggered, and any errors.
```

Disable
To temporarily stop shutdown and wake‑up scheduling:

```bash
sudo touch /tmp/disable_wakeup
Remove the file to re‑enable.
```
Uninstall
To remove the cron job and script:

```bash
sudo ./uninstall.sh
```
