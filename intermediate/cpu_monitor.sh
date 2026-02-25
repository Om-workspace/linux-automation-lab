#!/bin/bash

LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1)

echo "Current CPU Load: $LOAD"

THRESHOLD=2.00

awk -v load="$LOAD" -v threshold="$THRESHOLD" '
BEGIN {
    if (load > threshold)
        print "⚠ High CPU Load!"
    else
        print "✅ CPU Load is normal."
}'
