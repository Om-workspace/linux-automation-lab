#!/bin/bash

LOGFILE="/var/log/syslog"

echo "Searching for ERROR entries..."

grep -i "error" $LOGFILE | tail -n 5
