#!/bin/sh

# Function to detect if the system is OpenWrt 22.0 or above or snapshot
detect_openwrt() {
    local allow_snapshots="$1"  # Accept the allow_snapshots flag as an argument

    # Check if /etc/openwrt_release exists and uci command is available
    if [ ! -f /etc/openwrt_release ] || ! command -v uci >/dev/null 2>&1; then
        message "[ERROR] This script is designed to run on OpenWrt systems only."
        exit 1
    fi

    # Extract OpenWrt version and sanitize it
    openwrt_version=$(grep "DISTRIB_RELEASE" /etc/openwrt_release | cut -d'=' -f2 | tr -d '"')
    openwrt_version=$(echo "$openwrt_version" | tr -d "'")  # Remove single quotes if present

    # Check if the version is a SNAPSHOT build
    if echo "$openwrt_version" | grep -qi "snapshot"; then
        if [ "$allow_snapshots" != "1" ]; then
            message "[ERROR] This script requires OpenWrt version 22.0 or higher. Detected version: $openwrt_version."
            exit 1
        else
            message "[WARNING] Running on OpenWrt SNAPSHOT build ($openwrt_version). Proceeding due to --allowsnapshots flag."
            for i in $(seq 10 -1 1); do
                echo -ne "  Starting in $i seconds...\r"
                sleep 1
            done
            echo
        fi
    else
        # Fallback for version comparison if dpkg is unavailable
        if command -v dpkg >/dev/null 2>&1; then
            if dpkg --compare-versions "$openwrt_version" ge "22.0"; then
                log "[INFO] OpenWrt $openwrt_version detected. Continuing..."
                return 0
            else
                message "[ERROR] This script requires OpenWrt version 22.0 or higher. Detected version: $openwrt_version."
                exit 1
            fi
        else
            # Use sort -V as a fallback for version comparison
            if printf "%s\n%s\n" "22.0" "$openwrt_version" | sort -V | head -n1 | grep -q "^22.0$"; then
                message "[INFO] OpenWrt $openwrt_version detected. Continuing..."
                return 0
            else
                message "[ERROR] This script requires OpenWrt version 22.0 or higher. Detected version: $openwrt_version."
                exit 1
            fi
        fi
    fi
}

# Helper function to check if the system is a SNAPSHOT build
is_snapshot_build() {
    # Extract the DISTRIB_RELEASE field and check for "SNAPSHOT"
    if grep -q "^DISTRIB_RELEASE=" /etc/openwrt_release 2>/dev/null; then
        local release=$(grep "^DISTRIB_RELEASE=" /etc/openwrt_release | cut -d'=' -f2 | tr -d '"')
        echo "$release" | grep -qi "snapshot" >/dev/null && return 0 || return 1
    else
        return 1  # Return false if DISTRIB_RELEASE is not found
    fi
}

# Helper Function to check if the device is configured as a Dumb AP
# Assumes the device is a Dumb AP by default if network.lan.dhcp does not exist
is_dumb_ap() {
    # Check if network.lan.dhcp exists
    dhcp_value=$(uci get network.lan.dhcp 2>/dev/null)
    if [ -n "$dhcp_value" ]; then
        # If it exists and is set to "0", the device is a Dumb AP
        if [ "$dhcp_value" = "0" ]; then
            return 0  # True: Device is a Dumb AP
        else
            return 1  # False: Device is not a Dumb AP
        fi
    else
        # If network.lan.dhcp does not exist, assume the device is a Dumb AP by default
        return 0  # True: Device is a Dumb AP
    fi
}

# Validate Private IPv4 Address Format
validate_ip() {
    local ip="$1"
    if echo "$ip" | grep -Eq "^(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})$"; then
        return 0
    else
        return 1
    fi
}

# Enable IGMP Snooping
enable_igmp_snooping() {
    log_message "[INFO] Enabling IGMP snooping on the bridge interface..."
    if uci set network.lan.igmp_snooping='1'; then
        log "[OK] IGMP snooping enabled on the bridge interface (not yet applied)"
        additional_message="[OK] IGMP snooping enabled on the bridge interface (not yet applied)"
    else
        log "[ERROR] Failed to enable IGMP snooping."
        additional_message="[ERROR] Failed to enable IGMP snooping."
    fi
}

