#!/bin/sh

TOOL_NAME="Configure Device IP"

run_tool_device_ip() {
    while true; do
        banner
        echo "Select your LAN IP address:"
        echo "1) 192.168.1.1"
        echo "2) 192.168.0.1"
        echo "3) 10.0.0.1"
        echo "4) Manually enter IP"
        echo "0) Go back to Tools menu"
        read -r lan_choice
        case $lan_choice in
            1) lan_ip="192.168.1.1"; break ;;
            2) lan_ip="192.168.0.1"; break ;;
            3) lan_ip="10.0.0.1"; break ;;
            4)
                while true; do
		banner
                    echo "Enter LAN IP (format: x.x.x.x):"
                    read -r lan_ip
                    if validate_ip "$lan_ip"; then
                        break
                    else
                        log "[ERROR] Invalid IP format entered: $lan_ip"
                        additional_message="[ERROR] Invalid IP format! Try again."
                    fi
                done
                break
                ;;
            0) return ;; # Return to Tools menu
            *)
                log "[ERROR] Invalid option selected: $lan_choice"
                additional_message="[ERROR] Invalid option! Choose 1-4 or 0 to go back."
                ;;
        esac
    done

    if uci set network.lan.ipaddr="$lan_ip"; then
        log "[OK] LAN IP configured to $lan_ip (not yet applied)"
        additional_message="[OK] LAN IP configured to $lan_ip (not yet applied)"
    else
        log "[ERROR] Failed to configure LAN IP: $lan_ip"
        additional_message="[ERROR] Failed to configure LAN IP. Please try again."
    fi
}