#!/bin/sh

ENHANCEMENT_NAME="Set Device as Dumb AP"

run_enhancement_dumb_ap() {
    banner
    echo "[WARNING] Setting this device as a Dumb AP will disable DHCP, WAN, and WAN6 interfaces."
    echo "[WARNING] Other options like Network Tools and ISP Settings will no longer be available."
    echo "[WARNING] Do you want to proceed? (y/n)"
    read -r confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log "[INFO] Operation canceled by user."
        additional_message="[INFO] Operation canceled. Returning to the main menu."
        return
    fi

    echo "Enter the main router's gateway IP (e.g., 192.168.1.1):"
    read -r gateway_ip
    if ! validate_ip "$gateway_ip"; then
        log "[ERROR] Invalid gateway IP format entered: $gateway_ip"
        additional_message="[ERROR] Invalid gateway IP format! Operation canceled."
        return
    fi

    base_ip=$(echo "$gateway_ip" | cut -d'.' -f1-3)
    dumb_ap_ip=$(select_dumb_ap_ip "$base_ip")
    if [ -z "$dumb_ap_ip" ]; then
        log "[WARNING] Dumb AP IP selection canceled by user."
        additional_message="[WARNING] Dumb AP IP selection canceled. Returning to the main menu."
        return
    fi

    if uci set network.lan.ipaddr="$dumb_ap_ip"; then
        log "[OK] Dumb AP IP set to $dumb_ap_ip (not yet applied)"
        additional_message="[OK] Dumb AP IP set to $dumb_ap_ip (not yet applied)"
    else
        log "[ERROR] Failed to set Dumb AP IP: $dumb_ap_ip"
        additional_message="[ERROR] Failed to set Dumb AP IP. Please try again."
        return
    fi

    log "[OK] This device has been configured as a Dumb AP (not yet applied)."
    additional_message="[OK] This device has been configured as a Dumb AP (not yet applied). Restart to apply changes."
}