#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=90
EMAIL="maridinesh2202@gmail.com"

# Get current CPU usage (average over 1 minute)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
# Get current memory usage (percentage)
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
# Get current disk usage (percentage)
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Function to send email alert
send_alert() {
    SUBJECT="System Alert: Threshold Exceeded"
    BODY=$1
    echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
}

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    send_alert "CPU usage is high: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
fi

# Check memory usage
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    send_alert "Memory usage is high: ${MEMORY_USAGE}% (Threshold: ${MEMORY_THRESHOLD}%)"
fi

# Check disk usage
if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
    send_alert "Disk usage is high: ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
fi

# Check running processes (e.g., count number of processes)
PROCESS_COUNT=$(ps aux | wc -l)
PROCESS_THRESHOLD=100
if (( PROCESS_COUNT > PROCESS_THRESHOLD )); then
    send_alert "Number of running processes is high: ${PROCESS_COUNT} (Threshold: ${PROCESS_THRESHOLD})"
fi

