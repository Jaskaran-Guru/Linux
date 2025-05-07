#!/bin/bash

while true; do
  CHOICE=$(zenity --list \
    --title="SysMon Toolkit Launcher" \
    --text="Choose an option to execute:" \
    --column="Tool" \
    "Start or Install a Service" \
    "System Summary Notification" \
    "Setup Cron Auto-Launch" \
    "Exit")

  case "$CHOICE" in
    "System Summary Notification")
      bash notifier.sh
      ;;

    "Setup Cron Auto-Launch")
      bash setup_cron.sh
      ;;

    "Start or Install a Service")
      while true; do
        SERVICE=$(zenity --entry --title="Service Manager" --text="Enter service name (e.g., apache2, ssh):")

        # Break if Cancel is pressed
        if [[ $? -ne 0 ]]; then
          break
        fi

        if systemctl list-unit-files | grep -qw "^${SERVICE}.service"; then
          while true; do
            ACTION=$(zenity --list \
              --title="Manage Service: $SERVICE" \
              --text="Choose an action for '$SERVICE':" \
              --column="Action" \
              "Start" "Stop" "Restart" "Status" "Enable" "Disable" "Back")

            case "$ACTION" in
              "Start")
                sudo systemctl start "$SERVICE" && \
                zenity --info --text="✅ Service '$SERVICE' started." || \
                zenity --error --text="❌ Failed to start '$SERVICE'."
                ;;
              "Stop")
                sudo systemctl stop "$SERVICE" && \
                zenity --info --text="🛑 Service '$SERVICE' stopped." || \
                zenity --error --text="❌ Failed to stop '$SERVICE'."
                ;;
              "Restart")
                sudo systemctl restart "$SERVICE" && \
                zenity --info --text="🔄 Service '$SERVICE' restarted." || \
                zenity --error --text="❌ Failed to restart '$SERVICE'."
                ;;
              "Status")
                STATUS=$(systemctl status "$SERVICE" | head -n 30)
                zenity --info --width=600 --height=400 --text="$STATUS"
                ;;
              "Enable")
                sudo systemctl enable "$SERVICE" && \
                zenity --info --text="✅ Service '$SERVICE' enabled to start at boot." || \
                zenity --error --text="❌ Failed to enable '$SERVICE'."
                ;;
              "Disable")
                sudo systemctl disable "$SERVICE" && \
                zenity --info --text="❌ Service '$SERVICE' disabled from boot." || \
                zenity --error --text="⚠️ Failed to disable '$SERVICE'."
                ;;
              "Back" | *)
                break
                ;;
            esac
          done
        else
          zenity --question --text="❓ Service '$SERVICE' not found.\nDo you want to try installing it?"
          if [[ $? -eq 0 ]]; then
            sudo apt update
            sudo apt install -y "$SERVICE"

            if systemctl list-unit-files | grep -qw "^${SERVICE}.service"; then
              sudo systemctl start "$SERVICE"
              zenity --info --text="✅ Service '$SERVICE' installed and started."
            else
              zenity --error --text="❌ Service '$SERVICE' could not be installed or has no systemd unit."
            fi
          fi
        fi
      done
      ;;

    "Exit")
      exit 0
      ;;

    *)
      break
      ;;
  esac
done

