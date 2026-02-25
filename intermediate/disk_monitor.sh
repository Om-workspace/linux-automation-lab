#!/bin/bash

THRESHOLD=80
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "$(date): WARNING - Disk usage is ${USAGE}%" >> disk_alert.log
    echo "⚠ Disk usage is high: ${USAGE}%"
else
    echo "✅ Disk usage normal: ${USAGE}%"
fi
