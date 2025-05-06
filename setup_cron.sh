#!/bin/bash

SCRIPT_PATH="$(realpath notifier.sh)"

# Add @reboot cron job if not already added
(crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH") || (
  (crontab -l 2>/dev/null; echo "@reboot $SCRIPT_PATH") | crontab -
)

zenity --info --title="🎉 Cron Setup Complete" \
  --text="📌 <b>notifier.sh</b> will now run automatically at every system boot!"
