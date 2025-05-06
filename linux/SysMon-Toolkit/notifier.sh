#!/bin/bash

#  Gather system info
UPTIME=$(uptime -p)
MEMORY=$(free -h | awk '/Mem:/ {print $3 " used of " $2}')
DISK=$(df -h / | awk '$NF=="/"{print $3 " used of " $2}')
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | sed 's/^ *//')
USERS=$(who | wc -l)

#  Quote fallbak
if command -v fortune >/dev/null; then
  QUOTE=$(fortune -s)
else
  QUOTE=$(shuf -n 1 quotes.txt 2>/dev/null || echo "Keep pushing forward.")
fi

#  Display with Zenity
zenity --info --title="Daily System Report" --width=400 --height=300 \
  --text="<b>System Summary:</b>\n
<b>Uptime:</b> $UPTIME
 <b>Memory:</b> $MEMORY
 <b>Disk:</b> $DISK
 <b>Users Logged In:</b> $USERS
 <b>Load Avg:</b> $LOAD

 <b>Quote of the Day:</b>
$QUOTE"
