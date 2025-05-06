#!/bin/bash

CHOICE=$(zenity --list \
  --title="SysMon Toolkit Launcher" \
  --text="Choose an option to execute:" \
  --column="Tool" \
  "System Summary Notification" \
  "Service Manager Dashboard" \
  "Setup Cron Auto-Launch" \
  "Exit")

case "$CHOICE" in
  "System Summary Notification")
    bash notifier.sh
    ;;
  "Service Manager Dashboard")
    bash service_dashboard.sh
    ;;
  "Setup Cron Auto-Launch")
    bash setup_cron.sh
    ;;
  "Exit")
    exit 0
    ;;
  *)
    zenity --error --text="No valid option selected."
    ;;
esac
