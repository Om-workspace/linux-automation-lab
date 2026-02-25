#!/bin/bash

LOGFILE="monitor.log"
THRESHOLD_DISK=80
THRESHOLD_CPU=2.0
PROCESS="bash"

while getopts "p:d:c:" opt; do
  case $opt in
    p) PROCESS=$OPTARG ;;
    d) THRESHOLD_DISK=$OPTARG ;;
    c) THRESHOLD_CPU=$OPTARG ;;
    *) echo "Usage: $0 -p process -d disk_threshold -c cpu_threshold"
       exit 1 ;;
  esac
done

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

check_disk() {
    USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$USAGE" -gt "$THRESHOLD_DISK" ]; then
        log "WARNING: Disk usage high - ${USAGE}%"
    else
        log "Disk usage normal - ${USAGE}%"
    fi
}

check_cpu() {
    LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1)

    awk -v cpu_load="$LOAD" -v threshold="$THRESHOLD_CPU" '
    BEGIN {
        if (cpu_load > threshold)
            print "WARNING: High CPU Load - " cpu_load
        else
            print "CPU Load Normal - " cpu_load
    }' | while read line; do log "$line"; done
}

check_process() {
    if pgrep $PROCESS > /dev/null; then
        log "Process $PROCESS is running"
    else
        log "Process $PROCESS is NOT running"
    fi
}

main() {
    log "----- Monitoring Started -----"
    check_disk
    check_cpu
    check_process
    log "----- Monitoring Finished -----"
}

main