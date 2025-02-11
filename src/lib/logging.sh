#!/bin/sh
log() {
    local message="$1"
    log_file="/var/log/openwrt-ice-t.log"
    # Ensure the log file exists and is writable
    if [ ! -f "$log_file" ]; then
        touch "$log_file" 2>/dev/null || { echo "[WARNING] Unable to create log file. Logging disabled."; return; }
    fi
    if [ ! -w "$log_file" ]; then
        echo "[WARNING] Log file is not writable. Logging disabled."
        return
    fi
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - $message" >> "$log_file"
}