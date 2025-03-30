#!/bin/bash

# Threshold values
CPU=80
MEMORY=80
DISK=80

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "CPU Usage: $cpu_usage%"
if (( $(echo "$cpu_usage > $CPU" | bc -l) )); then
  echo "ALERT: CPU usage is above $CPU%!" >> /var/log/system_health.log
fi

# Check Memory usage
memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "Memory Usage: $memory_usage%"
if (( $(echo "$memory_usage > $MEMORY" | bc -l) )); then
  echo "ALERT: Memory usage is above $MEMORY%!" >> /var/log/system_health.log
fi

# Check Disk usage
disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
echo "Disk Usage: $disk_usage%"
if [ "$disk_usage" -gt "$DISK" ]; then
  echo "ALERT: Disk usage is above $DISK%!" >> /var/log/system_health.log
fi
