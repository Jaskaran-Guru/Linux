#!/bin/bash

# notifier.sh - Part of System Toolkit
# Sends a GUI notification with system stats (uptime, memory, disk, CPU)

# Get system info
uptime_info=$(uptime -p)
memory_usage=$(free -h | grep Mem | awk '{print $3 " used / " $2}')
disk_usage=$(df -h / | tail -1 | awk '{print $3 " used / " $2}')
cpu_load=$(top -bn1 | grep "load average" | awk -F'load average:' '{ print $2 }')

# Combine message
message="🖥️ System Status Notification\n\n"
message+="⏱️ Uptime: $uptime_info\n"
message+="🧠 Memory: $memory_usage\n"
message+="💾 Disk: $disk_usage\n"
message+="⚙️ CPU Load: $cpu_load"

# Check for Zenity
if command -v zenity >/dev/null 2>&1; then
    zenity --info --title="System Toolkit Notifier" --text="$message" --width=300
# Fallback to notify-send
elif command -v notify-send >/dev/null 2>&1; then
    notify-send "System Toolkit" "$message"
else
    echo -e "$message"
fi

