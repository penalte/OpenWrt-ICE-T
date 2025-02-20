#!/bin/sh

ISP_COUNTRY="Portugal"
ISP_NAME="Vodafone"

run_isp_portugal_vodafone() {
    while true; do
        banner
        echo "Configuring $ISP_NAME ($ISP_COUNTRY): "
        echo "1) Internet (Support coming soon)"
        echo "2) IPTV (Support coming soon)"
        echo "3) VOIP (Support coming soon)"
        echo "0) Go back to Main Menu"
        read -r vodafone_choice
        case $vodafone_choice in
            1|2|3)
                log "[WARNING] Support for $ISP_NAME ($ISP_COUNTRY) is coming soon."
                additional_message="[WARNING] Support for $ISP_NAME ($ISP_COUNTRY) is coming soon."
                ;;
            0)
                additional_message="[WARNING] $ISP_NAME ($ISP_COUNTRY): Configuration not applied."
                display_main_menu  # Return to the main menu
                return
                ;;
            *)
                log "[ERROR] Invalid option selected: $vodafone_choice"
                additional_message="[ERROR] Invalid option! Choose 1-4."
                ;;
        esac
    done
} 