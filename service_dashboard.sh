#!/bin/bash

while true; do
  ACTION=$(zenity --list --radiolist \
    --title="🛠️ Linux Service Manager" \
    --column="✔" --column="Action" \
    TRUE "View Status" \
    FALSE "Start Service" \
    FALSE "Stop Service" \
    FALSE "Enable Service" \
    FALSE "Disable Service" \
    FALSE "Exit")

  case $ACTION in
    "View Status")
      SVC=$(zenity --entry --title="Service Status" --text="Enter service name (e.g., ssh):")
      STATUS=$(systemctl status "$SVC" 2>&1 | head -n 30)
      zenity --text-info --title="Status: $SVC" --width=600 --height=400 --filename=<(echo "$STATUS")
      ;;
    "Start Service")
      SVC=$(zenity --entry --title="Start Service" --text="Enter service name:")
      sudo systemctl start "$SVC" && zenity --info --text="✅ $SVC started."
      ;;
    "Stop Service")
      SVC=$(zenity --entry --title="Stop Service" --text="Enter service name:")
      sudo systemctl stop "$SVC" && zenity --info --text="🛑 $SVC stopped."
      ;;
    "Enable Service")
      SVC=$(zenity --entry --title="Enable Service" --text="Enter service name:")
      sudo systemctl enable "$SVC" && zenity --info --text="🔄 $SVC enabled at boot."
      ;;
    "Disable Service")
      SVC=$(zenity --entry --title="Disable Service" --text="Enter service name:")
      sudo systemctl disable "$SVC" && zenity --info --text="🚫 $SVC disabled."
      ;;
    "Exit" | *)
      break
      ;;
  esac
done
